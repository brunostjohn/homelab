<script lang="ts">
	import { AppCard } from "../app";
	import { GrafanaIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Grafana"
	description="View metrics & their visualisations."
	gradientColours={["#ef5a27", "#f58324", "#fac20f"]}
	href={`https://window.${domain}`}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<GrafanaIcon />
		</div>
	{/snippet}
</AppCard>
