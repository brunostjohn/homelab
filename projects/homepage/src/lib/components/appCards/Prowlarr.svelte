<script lang="ts">
	import { AppCard } from "../app";
	import { ProwlarrIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Prowlarr"
	description="Torrent & Usenet indexer aggregator."
	gradientColours={["#e4630d", "#e4630d", "#e4630d"]}
	href="https://prowlarr.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<ProwlarrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
