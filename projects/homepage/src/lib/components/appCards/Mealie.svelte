<script lang="ts">
	import { AppCard } from "../app";
	import { AudiobookshelfIcon, MealieIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Mealie"
	description="Stash recipes, plan meals."
	href="https://mealie.{domain}"
	gradientColours={["#e88424", "#e88424", "#c89c53"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<MealieIcon />
		</div>
	{/snippet}
</AppCard>
