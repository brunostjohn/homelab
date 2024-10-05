import { env } from "$env/dynamic/private";
import t from "$lib/trpc/t";
import { Client as SabClient } from "sabnzbd-api";
import { QBittorrent, TorrentState } from "@ctrl/qbittorrent";
import { DownloadState, type InProgressDownload } from "./downloadClientsTypes";

const qbit = new QBittorrent({
	baseUrl: env.QBITTORRENT_URL,
	username: env.QBITTORRENT_USERNAME,
	password: env.QBITTORRENT_PASSWORD,
});

const sab = new SabClient(env.SABNZBD_URL ?? "", env.SABNZBD_API_KEY ?? "");

export const downloadClientsRouter = t.router({
	getActiveDownloads: t.procedure.query(async () => {
		const allDownloads: InProgressDownload[] = [];

		const torrents = await qbit.listTorrents();
		allDownloads.push(
			...torrents
				.filter(
					(torrent) =>
						torrent.state !== TorrentState.Uploading &&
						torrent.state !== TorrentState.StalledUP &&
						torrent.state !== TorrentState.CheckingUP &&
						torrent.state !== TorrentState.QueuedUP &&
						torrent.state !== TorrentState.PausedUP &&
						torrent.state !== TorrentState.ForcedUP
				)
				.map(({ name, progress, eta, size, dlspeed, downloaded, added_on, state }) => ({
					name,
					progress,
					etaSeconds: eta,
					sizeBytes: size,
					downloadSpeedBytes: dlspeed,
					downloadedBytes: downloaded,
					type: "torrent" as const,
					startedAtTimestamp: added_on,
					state: normaliseTorrentDownloadState(state),
				}))
		);

		const { slots: usenetDownloads, kbpersec, ...rest } = await sab.queue();

		allDownloads.push(
			...usenetDownloads
				.filter(
					({ status }) =>
						status === "Downloading" ||
						status === "Queued" ||
						status === "Propagating" ||
						status === "Fetching"
				)
				.map(({ filename, mb, mbleft, percentage, timeleft }) => ({
					type: "nzb" as const,
					name: filename,
					progress: parseFloat(percentage),
					downloadedBytes: (parseFloat(mb) - parseFloat(mbleft)) * 1024 * 1024,
					sizeBytes: parseFloat(mb) * 1024 * 1024,
					etaSeconds: parseTimeFromNzbEta(timeleft),
					downloadSpeedBytes: parseFloat(kbpersec) * 1024,
					startedAtTimestamp: null,
					state: normaliseNzbDownloadState(rest.status),
				}))
		);

		return allDownloads.sort((a, b) => a.progress - b.progress).reverse();
	}),
});

const parseTimeFromNzbEta = (eta: string) => {
	const [hours, minutes, seconds] = eta.split(":");
	return parseInt(hours) * 60 * 60 + parseInt(minutes) * 60 + parseInt(seconds);
};

const normaliseNzbDownloadState = (state: string) => {
	switch (state) {
		case "Downloading":
			return DownloadState.Downloading;
		case "Queued":
			return DownloadState.Queued;
		case "Propagating":
			return DownloadState.Processing;
		case "Fetching":
			return DownloadState.Processing;
		default:
			return DownloadState.Paused;
	}
};

const normaliseTorrentDownloadState = (state: TorrentState) => {
	switch (state) {
		case TorrentState.Downloading:
			return DownloadState.Downloading;
		case TorrentState.PausedDL:
			return DownloadState.Paused;
		case TorrentState.CheckingDL:
			return DownloadState.Processing;
		case TorrentState.QueuedDL:
			return DownloadState.Queued;
		default:
			return DownloadState.Paused;
	}
};
