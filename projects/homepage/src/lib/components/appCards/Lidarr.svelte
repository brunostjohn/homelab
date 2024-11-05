<script lang="ts">
	import { AppCard } from "../app";
	import { LidarrIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Lidarr"
	description="Music fetcher & manager."
	gradientColours={["#049454", "#049454", "#049454"]}
	href="https://lidarr.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<LidarrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
