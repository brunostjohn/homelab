<script lang="ts">
	import { AppCard } from "../app";
	import { ManyfoldIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Manyfold"
	description="Store & categorise 3D print files."
	gradientColours={["#1484fb", "#74b4fc", "#bed9f5"]}
	href={`https://manyfold.${domain}`}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square overflow-hidden {className}">
			<ManyfoldIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
