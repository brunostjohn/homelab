<script lang="ts">
	import { AppCard } from "../app";
	import { NetboxIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Netbox"
	description="View information about our infrastructure."
	gradientColours={["#1484fb", "#1484fb", "#74b4fc"]}
	href={`https://window.${domain}`}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<NetboxIcon />
		</div>
	{/snippet}
</AppCard>
