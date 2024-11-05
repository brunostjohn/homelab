<script lang="ts">
	import { AppCard } from "../app";
	import { SonarrIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Sonarr"
	description="Show fetcher & manager."
	gradientColours={["#3c3c54", "#3c3c54", "#3c3c54"]}
	href="https://sonarr.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<SonarrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
