<script lang="ts">
	import { AppCard } from "../app";
	import { JellyfinIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Jellyfin"
	description="Watch movies & shows, listen to music."
	gradientColours={["#020b23", "#1f52aa", "#226e80"]}
	href={`https://birds.${domain}`}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<JellyfinIcon class={className} />
	{/snippet}
</AppCard>
