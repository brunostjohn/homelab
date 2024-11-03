<script lang="ts">
	import { AppCardList, PageTitle } from "$lib/components/app";
	import {
		AuthentikAppCard,
		EMQXAppCard,
		GrafanaAppCard,
		iDRACAppCard as IDRACAppCard,
		InfisicalAppCard,
		KibanaAppCard,
		LonghornAppCard,
		MinioAppCard,
		NetboxAppCard,
		ProxmoxAppCard,
		RabbitMQAppCard,
		TraefikAppCard,
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
	<InfisicalAppCard {domain} />
	<EMQXAppCard />
	<Zigbee2MQTTAppCard />
	<RabbitMQAppCard />
	<TraefikAppCard />
</AppCardList>

<AppCardList title="Hardware">
	<ProxmoxAppCard />
	<NetboxAppCard {domain} />
	<IDRACAppCard />
	<UniFiNetworkAppCard />
</AppCardList>

<AppCardList title="Storage">
	<MinioAppCard {domain} />
	<LonghornAppCard />
	<TrueCommandAppCard {domain} />
	<TrueNASScaleAppCard />
</AppCardList>
