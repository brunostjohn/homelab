<script lang="ts">
	import { AppCard } from "../app";
	import { RabbitMQIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();
</script>

<AppCard
	name="RabbitMQ"
	description="AMQP message broker."
	href="http://10.0.2.28:15692}"
	gradientColours={["#fc6404", "#fc6404", "#fc6404"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-2 {className}">
			<RabbitMQIcon class="" />
		</div>
	{/snippet}
</AppCard>
