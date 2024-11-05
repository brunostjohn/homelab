<script lang="ts">
	import { AppCard } from "../app";
	import { CoderIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Coder"
	description="Instantly provision a coding environment."
	gradientColours={["#343434", "#414141", "#4c4c4c"]}
	href="https://envs.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<CoderIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
