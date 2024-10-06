<script lang="ts">
	import { AppCard } from "../app";
	import { JellyseerrIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Jellyseerr"
	description="Request movies & shows to be downloaded."
	gradientColours={["#8b74ea", "#b099f7", "#cdaefa"]}
	href="https://den.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<JellyseerrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
