<script lang="ts">
	import { JellyfinLatestCarousel } from "$lib/components/media";
	import type { PageServerData } from "./$types";
	import { Cloud, Popcorn } from "lucide-svelte";
	import {
		AudiobookshelfAppCard,
		ImmichAppCard,
		JellyfinAppCard,
		RommAppCard,
		VaultwardenAppCard,
		NextcloudAppCard,
	} from "$lib/components/appCards";
	import { AppCardList, HomepageSectionTitle, SeeMoreApps } from "$lib/components/app";
	import { JellyfinIcon } from "$lib/components/icons";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { domain } = $derived(data);
</script>

<HomepageSectionTitle
	title="Latest Movies & Shows"
	seeMoreAppName="Jellyfin"
	seeMoreHref={`https://birds.${domain}`}
>
	{#snippet titleIcon(className: string)}
		<Popcorn class={className} />
	{/snippet}

	{#snippet seeMoreIcon(className: string)}
		<JellyfinIcon class={className} />
	{/snippet}
</HomepageSectionTitle>
<JellyfinLatestCarousel {domain} />
<AppCardList title="Entertainment Apps" onHome>
	<JellyfinAppCard {domain} />
	<RommAppCard {domain} />
	<AudiobookshelfAppCard {domain} />
	<SeeMoreApps description="Request media, check on your downloads." href="/entertainment" />
</AppCardList>

<HomepageSectionTitle title="RecentFiles">
	{#snippet titleIcon(className: string)}
		<Cloud class={className} />
	{/snippet}
</HomepageSectionTitle>
<AppCardList title="Personal Cloud Apps" onHome>
	<ImmichAppCard {domain} />
	<VaultwardenAppCard {domain} />
	<NextcloudAppCard {domain} />
</AppCardList>
