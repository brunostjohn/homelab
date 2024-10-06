<script lang="ts">
	import { Carousel, Card } from "$lib/components/ui";
	import { trpc } from "$lib/trpc";
	import Autoplay from "embla-carousel-autoplay";
	import JellyfinCarouselCard from "./JellyfinCarouselCard.svelte";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	const jfData = trpc()?.jellyfin.latestMedia.createQuery();
</script>

<Carousel.Root
	class="mx-auto mb-2 w-full"
	opts={$jfData?.data
		? {
				loop: true,
			}
		: undefined}
	plugins={$jfData?.data
		? [
				Autoplay({
					delay: 5000,
				}),
			]
		: undefined}
>
	<Carousel.Content>
		{#if $jfData?.data}
			{#each $jfData.data as item}
				<JellyfinCarouselCard {item} {domain} />
			{/each}
		{:else}
			<Carousel.Item>
				<Card.Root class="bg-muted animate-pulse">
					<Card.Content class="flex h-96 min-h-96 items-end justify-start p-6"></Card.Content>
				</Card.Root>
			</Carousel.Item>
		{/if}
	</Carousel.Content>
	<Carousel.Previous />
	<Carousel.Next />
</Carousel.Root>
