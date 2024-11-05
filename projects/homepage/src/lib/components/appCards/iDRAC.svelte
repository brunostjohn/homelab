<script lang="ts">
	import { MultiInstanceAppCard } from "../app";
	import { iDRACIcon as IDRACIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();

	const instances = [
		{ name: "S1", href: "https://10.0.134.225" },
		{ name: "S2", href: "https://10.0.247.252" },
		{ name: "S3", href: "https://10.0.76.215" },
	];
</script>

<MultiInstanceAppCard
	name="iDRAC"
	description="Manage our Dell servers."
	gradientColours={["#087cbc", "#087cbc", "#087cbc"]}
	class={className}
	{instances}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<IDRACIcon class="" />
		</div>
	{/snippet}
</MultiInstanceAppCard>
