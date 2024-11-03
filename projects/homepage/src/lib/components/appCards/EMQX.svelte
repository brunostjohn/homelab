<script lang="ts">
	import { AppCard } from "../app";
	import { EMQXIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();
</script>

<AppCard
	name="EMQX"
	description="MQTT broker."
	href="http://10.0.2.27:18083}"
	gradientColours={["#8b622b", "#a07333", "#c89c53"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<EMQXIcon class="" />
		</div>
	{/snippet}
</AppCard>
