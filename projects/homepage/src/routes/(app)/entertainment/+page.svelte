<script lang="ts">
	import { ChevronLeft } from "lucide-svelte";
	import type { PageServerData } from "./$types";
	import {
		JellyfinRecentsCarousel,
		JellyseerrRequests,
		InProgressDownloads,
	} from "$lib/components/entertainment";
	import {
		AudiobookshelfAppCard,
		BazarrAppCard,
		JellyfinAppCard,
		JellyseerrAppCard,
		LidarrAppCard,
		ProwlarrAppCard,
		QBitTorrentAppCard,
		RadarrAppCard,
		ReadarrAppCard,
		RommAppCard,
		SABnzbdAppCard,
		SonarrAppCard,
	} from "$lib/components/appCards";

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
	<JellyfinAppCard {domain} />

	<RommAppCard {domain} />

	<AudiobookshelfAppCard {domain} />
</ul>

<JellyfinRecentsCarousel serverPublicUrl="https://birds.{domain}" {domain} />

<h2 class="align-center mb-2 mt-8 flex items-center gap-2 text-3xl font-semibold">Request Media</h2>
<JellyseerrAppCard {domain} notInList />
<JellyseerrRequests {domain} />

<h2 class="align-center mb-2 mt-8 flex items-center gap-2 text-3xl font-semibold">
	Media Fetchers
</h2>
<ul class="mb-4 mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
	<ProwlarrAppCard {domain} />
	<RadarrAppCard {domain} />
	<SonarrAppCard {domain} />
	<LidarrAppCard {domain} />
	<ReadarrAppCard {domain} />
	<BazarrAppCard {domain} />
</ul>

<h2 class="align-center mb-2 mt-8 flex items-center gap-2 text-3xl font-semibold">
	Media Downloaders
</h2>
<ul class="mb-4 mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
	<QBitTorrentAppCard {domain} />
	<SABnzbdAppCard {domain} />
</ul>

<InProgressDownloads />
