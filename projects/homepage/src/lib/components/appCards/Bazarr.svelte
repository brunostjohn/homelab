<script lang="ts">
	import { AppCard } from "../app";
	import { BazarrIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Bazarr"
	description="Subtitle fetcher & manager."
	gradientColours={["#000000", "#444444", "#777777"]}
	href="https://bazarr.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<BazarrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
