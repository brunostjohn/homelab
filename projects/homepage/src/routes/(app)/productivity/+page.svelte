<script lang="ts">
	import { AppCardList, PageTitle } from "$lib/components/app";
	import {
		CoderAppCard,
		GristAppCard,
		ITToolsAppCard,
		LinkwardenAppCard,
		ManyfoldAppCard,
		MemosAppCard,
		NocoDBAppCard,
		OllamaAppCard,
		PerplexityAppCard,
		PlaneAppCard,
		RallyAppCard,
		SearXNGAppCard,
		StirlingPDFAppCard,
		WindmillAppCard,
		OpenGistAppCard,
	} from "$lib/components/appCards";
	import type { PageServerData } from "./$types";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { domain } = $derived(data);
</script>

<PageTitle showBackButton>Productivity</PageTitle>

<AppCardList title="AI">
	<OllamaAppCard {domain} />
	<PerplexityAppCard {domain} />
</AppCardList>

<AppCardList title="Organisation & Documents">
	<GristAppCard {domain} />
	<NocoDBAppCard {domain} />
	<RallyAppCard {domain} />
	<PlaneAppCard {domain} />
	<ManyfoldAppCard {domain} />
</AppCardList>

<AppCardList title="Brain Dump">
	<MemosAppCard {domain} />
	<LinkwardenAppCard {domain} />
</AppCardList>

<AppCardList title="Tools">
	<StirlingPDFAppCard {domain} />
	<ITToolsAppCard {domain} />
	<SearXNGAppCard {domain} />
</AppCardList>

<AppCardList title="Programming & Automation">
	<WindmillAppCard {domain} />
	<CoderAppCard {domain} />
	<OpenGistAppCard {domain} />
</AppCardList>
