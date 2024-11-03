<script lang="ts">
	import { MultiInstanceAppCard } from "../app";
	import { TrueNASScaleIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();

	const instances = [
		{ name: "Jabberwock", href: "http://10.0.3.1" },
		{ name: "Lookingglass", href: "http://10.0.3.3" },
		{ name: "Floofpool", href: "http://10.0.3.5" },
	];
</script>

<MultiInstanceAppCard
	name="TrueNAS"
	description="Access our TrueNAS dashboards."
	gradientColours={["#04265b", "#043ca0", "#0451c4"]}
	class={className}
	{instances}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-2 {className}"
		>
			<TrueNASScaleIcon class="" />
		</div>
	{/snippet}
</MultiInstanceAppCard>
