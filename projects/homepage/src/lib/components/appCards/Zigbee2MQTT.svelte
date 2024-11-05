<script lang="ts">
	import { AppCard } from "../app";
	import { Zigbee2MQTTIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Zigbee2MQTT"
	description="Bridge Zigbee devices and MQTT."
	href="http://10.0.2.28:8080"
	gradientColours={["#bc8c2c", "#bc8c2c", "#bc8c2c"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<Zigbee2MQTTIcon class="" />
		</div>
	{/snippet}
</AppCard>
