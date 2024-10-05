export interface InProgressDownload {
	name: string;
	progress: number;
	downloadedBytes: number;
	sizeBytes: number;
	etaSeconds: number;
	startedAtTimestamp: number | null;
	downloadSpeedBytes: number;
	type: DownloadType;
	state: DownloadState;
}

export enum DownloadState {
	Downloading,
	Paused,
	Processing,
	Queued,
}

export type DownloadType = "torrent" | "nzb";
