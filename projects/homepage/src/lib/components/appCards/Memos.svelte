<script lang="ts">
	import { AppCard } from "../app";
	import { MemosIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Memos"
	description="Brain dump & note-taking."
	gradientColours={["#0b0b14", "#2c2b2c", "#444454"]}
	href="https://memos.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<MemosIcon class="rounded-md {className}" />
	{/snippet}
</AppCard>
