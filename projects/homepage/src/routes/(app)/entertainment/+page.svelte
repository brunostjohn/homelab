<script lang="ts">
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
	import { AppCardList, AppCardListTitle, PageTitle } from "$lib/components/app";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { domain } = $derived(data);
</script>

<PageTitle showBackButton>Entertainment</PageTitle>

<AppCardList title="Watch Media">
	<JellyfinAppCard {domain} />
	<RommAppCard {domain} />
	<AudiobookshelfAppCard {domain} />
</AppCardList>

<JellyfinRecentsCarousel {domain} />

<AppCardListTitle class="mt-6">Request Media</AppCardListTitle>
<JellyseerrAppCard {domain} notInList />
<JellyseerrRequests {domain} />

<AppCardList title="Media Fetchers" titleClass="mt-6">
	<ProwlarrAppCard {domain} />
	<RadarrAppCard {domain} />
	<SonarrAppCard {domain} />
	<LidarrAppCard {domain} />
	<ReadarrAppCard {domain} />
	<BazarrAppCard {domain} />
</AppCardList>

<AppCardList title="Media Downloaders" titleClass="mt-6">
	<QBitTorrentAppCard {domain} />
	<SABnzbdAppCard {domain} />
</AppCardList>

<InProgressDownloads />
