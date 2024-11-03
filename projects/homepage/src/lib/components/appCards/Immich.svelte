<script lang="ts">
	import { AppCard } from "../app";
	import { ImmichIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Immich"
	description="View and sync your photos."
	gradientColours={["#fb2b23", "#fb2b23", "#ec7cb4"]}
	href={`https://window.${domain}`}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<ImmichIcon />
		</div>
	{/snippet}
</AppCard>
