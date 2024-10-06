<script lang="ts">
	import { JellyfinLatestCarousel } from "$lib/components/media";
	import type { PageServerData } from "./$types";
	import { Cloud } from "lucide-svelte";
	import {
		AudiobookshelfAppCard,
		ImmichAppCard,
		JellyfinAppCard,
		RommAppCard,
		VaultwardenAppCard,
		NextcloudAppCard,
	} from "$lib/components/appCards";
	import { AppCardList, SeeMoreApps } from "$lib/components/app";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { domain } = $derived(data);
</script>

<JellyfinLatestCarousel {domain} />

<AppCardList title="Entertainment Apps" onHome>
	<JellyfinAppCard {domain} />
	<RommAppCard {domain} />
	<AudiobookshelfAppCard {domain} />
	<SeeMoreApps description="Request media, check on your downloads." href="/entertainment" />
</AppCardList>

<h1 class="align-center mt-8 flex items-center gap-2 text-4xl font-semibold">
	<Cloud class="h-8 w-8" />
	Recent Files
</h1>

<AppCardList title="Personal Cloud Apps" onHome>
	<ImmichAppCard {domain} />
	<VaultwardenAppCard {domain} />
	<NextcloudAppCard {domain} />
</AppCardList>
