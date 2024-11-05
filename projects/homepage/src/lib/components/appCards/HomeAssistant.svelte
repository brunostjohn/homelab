<script lang="ts">
	import { AppCard } from "../app";
	import { HomeAssistantIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Home Assistant"
	description="Control our home, set up automations."
	href="https://thekingdom.{domain}"
	gradientColours={["#1cbcf4", "#1cbcf4", "#1cbcf4"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<HomeAssistantIcon />
		</div>
	{/snippet}
</AppCard>
