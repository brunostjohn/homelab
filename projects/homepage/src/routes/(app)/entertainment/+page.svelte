<script lang="ts">
	import { ChevronLeft } from "lucide-svelte";
	import type { PageServerData } from "./$types";
	import { AppCard } from "$lib/components/app";
	import {
		AudiobookshelfIcon,
		BazarrIcon,
		JellyfinIcon,
		JellyseerrIcon,
		LidarrIcon,
		ProwlarrIcon,
		QBitTorrentIcon,
		RadarrIcon,
		ReadarrIcon,
		RommIcon,
		SABnzbdIcon,
		SonarrIcon,
	} from "$lib/components/icons";
	import {
		JellyfinRecentsCarousel,
		JellyseerrRequests,
		InProgressDownloads,
	} from "$lib/components/entertainment";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { domain } = $derived(data);
</script>

<a
	href="/"
	class="align-center text-muted-foreground hover:text-primary -ml-2 mb-1 flex items-center transition-all"
>
	<ChevronLeft />Go back home
</a>
<h1 class="align-center mb-6 flex items-center gap-2 text-4xl font-semibold">Entertainment</h1>

<h2 class="text-3xl font-semibold">Watch Media</h2>
<ul class="mb-4 mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
	<AppCard
		name="Jellyfin"
		description="Watch movies & shows, listen to music."
		gradientColours={["#020b23", "#1f52aa", "#226e80"]}
		href="https://birds.{domain}"
	>
		{#snippet icon(className: string)}
			<JellyfinIcon class={className} />
		{/snippet}
	</AppCard>

	<AppCard
		name="Romm"
		description="Collect & download game console roms."
		href="https://romm.{domain}"
		gradientColours={["#4200d0", "#7200df", "#ce00fb"]}
	>
		{#snippet icon(className: string)}
			<div class="aspect-square bg-white p-1 {className}">
				<RommIcon />
			</div>
		{/snippet}
	</AppCard>

	<AppCard
		name="Audiobookshelf"
		description="Listen to audiobooks & podcasts."
		href="https://audiobookshelf.{domain}"
		gradientColours={["#8b622b", "#a07333", "#c89c53"]}
	>
		{#snippet icon(className: string)}
			<div class="aspect-square bg-white p-1 {className}">
				<AudiobookshelfIcon />
			</div>
		{/snippet}
	</AppCard>
</ul>

<JellyfinRecentsCarousel serverPublicUrl="https://birds.{domain}" {domain} />

<h2 class="align-center mb-2 mt-8 flex items-center gap-2 text-3xl font-semibold">Request Media</h2>
<AppCard
	name="Jellyseerr"
	description="Request movies & shows to be downloaded."
	gradientColours={["#8b74ea", "#b099f7", "#cdaefa"]}
	href="https://den.{domain}"
	notInList
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<JellyseerrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>

<JellyseerrRequests {domain} />

<h2 class="align-center mb-2 mt-8 flex items-center gap-2 text-3xl font-semibold">
	Media Fetchers
</h2>
<ul class="mb-4 mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
	<AppCard
		name="Prowlarr"
		description="Torrent & Usenet indexer aggregator."
		gradientColours={["#7e2b1b", "#e4630d", "#fba37b"]}
		href="https://prowlarr.{domain}"
	>
		{#snippet icon(className: string)}
			<div class="rounded-md bg-white p-1 {className}">
				<ProwlarrIcon class="h-full w-full" />
			</div>
		{/snippet}
	</AppCard>

	<AppCard
		name="Radarr"
		description="Movie fetcher & manager."
		gradientColours={["#242c2c", "#fbc42c", "#f6dba0"]}
		href="https://radarr.{domain}"
	>
		{#snippet icon(className: string)}
			<div class="rounded-md bg-white p-1 {className}">
				<RadarrIcon class="h-full w-full" />
			</div>
		{/snippet}
	</AppCard>

	<AppCard
		name="Sonarr"
		description="Show fetcher & manager."
		gradientColours={["#3c3c54", "#3c3c54", "#04cbfb"]}
		href="https://sonarr.{domain}"
	>
		{#snippet icon(className: string)}
			<div class="rounded-md bg-white p-1 {className}">
				<SonarrIcon class="h-full w-full" />
			</div>
		{/snippet}
	</AppCard>

	<AppCard
		name="Lidarr"
		description="Music fetcher & manager."
		gradientColours={["#049454", "#afc0b4", "#b5cdbf"]}
		href="https://lidarr.{domain}"
	>
		{#snippet icon(className: string)}
			<div class="rounded-md bg-white p-1 {className}">
				<LidarrIcon class="h-full w-full" />
			</div>
		{/snippet}
	</AppCard>

	<AppCard
		name="Readarr"
		description="Book fetcher & manager."
		gradientColours={["#742c2c", "#bc847c", "#d4b4ac"]}
		href="https://readarr.{domain}"
	>
		{#snippet icon(className: string)}
			<div class="rounded-md bg-white p-1 {className}">
				<ReadarrIcon class="h-full w-full" />
			</div>
		{/snippet}
	</AppCard>

	<AppCard
		name="Bazarr"
		description="Subtitle fetcher & manager."
		gradientColours={["#000000", "#000000", "#ffffff"]}
		href="https://bazarr.{domain}"
	>
		{#snippet icon(className: string)}
			<div class="rounded-md bg-white p-1 {className}">
				<BazarrIcon class="h-full w-full" />
			</div>
		{/snippet}
	</AppCard>
</ul>

<h2 class="align-center mb-2 mt-8 flex items-center gap-2 text-3xl font-semibold">
	Media Downloaders
</h2>
<ul class="mb-4 mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
	<AppCard
		name="QBitTorrent"
		description="Torrent client."
		gradientColours={["#407bc9", "#64a4ec", "#a2ccf4"]}
		href="https://fetching.{domain}"
	>
		{#snippet icon(className: string)}
			<QBitTorrentIcon class={className} />
		{/snippet}
	</AppCard>

	<AppCard
		name="SABnzbd"
		description="Usenet client."
		gradientColours={["#8c620c", "#b6810b", "#fbc116"]}
		href="https://sabnzbd.{domain}"
	>
		{#snippet icon(className: string)}
			<div class="rounded-[8px] bg-white p-1 {className}">
				<SABnzbdIcon class="relative h-full w-full" />
			</div>
		{/snippet}
	</AppCard>
</ul>

<InProgressDownloads />
