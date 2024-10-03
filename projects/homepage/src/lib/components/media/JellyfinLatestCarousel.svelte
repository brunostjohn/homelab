<script lang="ts">
	import { Carousel } from "$lib/components/ui";
	import { trpc } from "$lib/trpc";
	import { Popcorn } from "lucide-svelte";
	import Autoplay from "embla-carousel-autoplay";
	import JellyfinCarouselCard from "./JellyfinCarouselCard.svelte";

	interface Props {
		serverPublicUrl: string;
	}

	const { serverPublicUrl }: Props = $props();

	const jfData = trpc()?.jellyfin.latestMedia.createQuery();
</script>

<h1 class="align-center mb-4 flex items-center gap-2 text-4xl font-semibold">
	<Popcorn class="h-8 w-8" />
	Latest Movies & Shows
</h1>
{#if $jfData?.data}
	<Carousel.Root
		class="mx-auto w-full"
		opts={{
			loop: true,
		}}
		plugins={[
			Autoplay({
				delay: 5000,
			}),
		]}
	>
		<Carousel.Content>
			{#each $jfData.data as item}
				<JellyfinCarouselCard {item} {serverPublicUrl} />
			{/each}
		</Carousel.Content>
		<Carousel.Previous />
		<Carousel.Next />
	</Carousel.Root>
{/if}
