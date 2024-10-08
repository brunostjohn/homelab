<script lang="ts">
	import { JellyfinLatestCarousel } from "$lib/components/media";
	import type { PageServerData } from "./$types";
	import { Cloud, Popcorn, Sparkles, House, HardDrive } from "lucide-svelte";
	import {
		AudiobookshelfAppCard,
		ImmichAppCard,
		JellyfinAppCard,
		RommAppCard,
		VaultwardenAppCard,
		NextcloudAppCard,
		HomeAssistantAppCard,
		MealieAppCard,
		PaperlessAppCard,
		UniFiNVRAppCard,
		OllamaAppCard,
		LinkwardenAppCard,
		MemosAppCard,
		GrafanaAppCard,
		MinioAppCard,
		NetboxAppCard,
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

<HomepageSectionTitle title="Recent Files">
	{#snippet titleIcon(className: string)}
		<Cloud class={className} />
	{/snippet}
</HomepageSectionTitle>
<AppCardList title="Personal Cloud Apps" onHome>
	<ImmichAppCard {domain} />
	<VaultwardenAppCard {domain} />
	<NextcloudAppCard {domain} />
</AppCardList>

<HomepageSectionTitle title="Your Newest Recipes">
	{#snippet titleIcon(className: string)}
		<House class={className} />
	{/snippet}
</HomepageSectionTitle>
<AppCardList title="Smart Home Apps" onHome>
	<HomeAssistantAppCard {domain} />
	<MealieAppCard {domain} />
	<PaperlessAppCard {domain} />
	<UniFiNVRAppCard />
</AppCardList>

<HomepageSectionTitle title="Recent Chats with AI">
	{#snippet titleIcon(className: string)}
		<Sparkles class={className} />
	{/snippet}
</HomepageSectionTitle>
<AppCardList title="Productivity Apps" onHome>
	<OllamaAppCard {domain} />
	<LinkwardenAppCard {domain} />
	<MemosAppCard {domain} />
	<SeeMoreApps description="Manage your life, keep track of things." href="/productivity" />
</AppCardList>

<HomepageSectionTitle title="Server Stats">
	{#snippet titleIcon(className: string)}
		<HardDrive class={className} />
	{/snippet}
</HomepageSectionTitle>
<AppCardList title="Management Apps" onHome>
	<GrafanaAppCard {domain} />
	<MinioAppCard {domain} />
	<NetboxAppCard {domain} />
	<SeeMoreApps description="Check metrics, monitor cluster health." href="/serverManagement" />
</AppCardList>
