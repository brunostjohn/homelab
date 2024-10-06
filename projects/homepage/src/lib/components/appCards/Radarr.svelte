<script lang="ts">
	import { AppCard } from "../app";
	import { RadarrIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Radarr"
	description="Movie fetcher & manager."
	gradientColours={["#242c2c", "#fbc42c", "#f6dba0"]}
	href="https://radarr.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<RadarrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
