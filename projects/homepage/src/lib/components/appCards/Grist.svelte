<script lang="ts">
	import { AppCard } from "../app";
	import { GristIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Grist"
	description="Python-powered spreadsheets."
	gradientColours={["#8b74ea", "#b099f7", "#cdaefa"]}
	href="https://grist.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<GristIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
