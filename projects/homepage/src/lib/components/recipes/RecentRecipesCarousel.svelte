<script lang="ts">
	import { Carousel } from "$lib/components/ui";
	import { trpc } from "$lib/trpc";
	import Autoplay from "embla-carousel-autoplay";
	import RecentRecipesCarouselItem from "./RecentRecipesCarouselItem.svelte";
	import RecentRecipesCarouselItemSkeleton from "./RecentRecipesCarouselItemSkeleton.svelte";
	import { onDestroy } from "svelte";
	import { createMediaStore } from "svelte-media-queries";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	const recentRecipes = trpc()?.mealie.newestRecipes.createQuery();

	const matches = createMediaStore("(min-width: 768px)");
	onDestroy(() => matches.destroy());
</script>

<Carousel.Root
	class="mb-2"
	opts={$recentRecipes?.data
		? {
				loop: true,
			}
		: undefined}
	plugins={$recentRecipes?.data
		? [
				Autoplay({
					delay: 5000,
				}),
			]
		: undefined}
>
	<Carousel.Content>
		{#if $recentRecipes?.data}
			{#each $recentRecipes?.data as recipe}
				<RecentRecipesCarouselItem {recipe} {domain} />
			{/each}
		{:else}
			{#each Array.from({ length: 3 }).map((_, i) => i) as _}
				<RecentRecipesCarouselItemSkeleton />
			{/each}
		{/if}
	</Carousel.Content>
	<Carousel.Previous />
	<Carousel.Next />
</Carousel.Root>
