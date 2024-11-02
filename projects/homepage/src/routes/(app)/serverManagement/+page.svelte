<script lang="ts">
	import { AppCardList, PageTitle } from "$lib/components/app";
	import {
		GrafanaAppCard,
		KibanaAppCard,
		MinioAppCard,
		NetboxAppCard,
	} from "$lib/components/appCards";
	import type { PageServerData } from "./$types";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { domain } = $derived(data);
</script>

<PageTitle showBackButton>Server Management</PageTitle>

<AppCardList title="Observability">
	<GrafanaAppCard {domain} />
	<KibanaAppCard {domain} />
</AppCardList>

<AppCardList title="Hardware">
	<NetboxAppCard {domain} />
</AppCardList>

<AppCardList title="Storage">
	<MinioAppCard {domain} />
</AppCardList>
