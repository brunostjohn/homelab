<script lang="ts">
	import { AppCard } from "../app";
	import { TrueCommandIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
		domain: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="TrueCommand"
	description="Manage our TrueNAS servers."
	href="https://truecommand.{domain}"
	gradientColours={["#0594d1", "#2c9dc3", "#189ed2"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-2 {className}"
		>
			<TrueCommandIcon class="" />
		</div>
	{/snippet}
</AppCard>
