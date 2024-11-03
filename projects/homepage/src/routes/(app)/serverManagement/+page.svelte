<script lang="ts">
	import { AppCardList, PageTitle } from "$lib/components/app";
	import {
		AuthentikAppCard,
		EMQXAppCard,
		GrafanaAppCard,
		KibanaAppCard,
		MinioAppCard,
		NetboxAppCard,
		ProxmoxAppCard,
		RabbitMQAppCard,
		TrueCommandAppCard,
		TrueNASScaleAppCard,
		UniFiNetworkAppCard,
		Zigbee2MQTTAppCard,
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

<AppCardList title="Administration">
	<AuthentikAppCard {domain} />
	<EMQXAppCard />
	<Zigbee2MQTTAppCard />
	<RabbitMQAppCard />
	<UniFiNetworkAppCard />
</AppCardList>

<AppCardList title="Hardware">
	<ProxmoxAppCard />
	<NetboxAppCard {domain} />
</AppCardList>

<AppCardList title="Storage">
	<MinioAppCard {domain} />
	<TrueCommandAppCard {domain} />
	<TrueNASScaleAppCard />
</AppCardList>
