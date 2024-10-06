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
	gradientColours={["#7e2b1b", "#e4630d", "#fba37b"]}
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
