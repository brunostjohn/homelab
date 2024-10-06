<script lang="ts">
	import { AppCard } from "../app";
	import { ReadarrIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Readarr"
	description="Book fetcher & manager."
	gradientColours={["#742c2c", "#bc847c", "#d4b4ac"]}
	href="https://readarr.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<ReadarrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
