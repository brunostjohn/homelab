<script lang="ts">
	import { Carousel, Card } from "$lib/components/ui";
	import { trpc } from "$lib/trpc";
	import { Popcorn, ChevronRight } from "lucide-svelte";
	import Autoplay from "embla-carousel-autoplay";
	import JellyfinCarouselCard from "./JellyfinCarouselCard.svelte";
	import { JellyfinIcon } from "../icons";

	interface Props {
		serverPublicUrl: string;
	}

	const { serverPublicUrl }: Props = $props();

	const jfData = trpc()?.jellyfin.latestMedia.createQuery();
</script>

<div class="align-center mb-4 flex items-center justify-center">
	<h1 class="align-center flex items-center gap-2 text-4xl font-semibold">
		<Popcorn class="h-8 w-8" />
		Latest Movies & Shows
	</h1>

	<a
		href={serverPublicUrl}
		target="_blank"
		class="align-center text-muted-foreground hover:text-primary ml-auto flex items-center text-sm transition-all"
	>
		See more on <JellyfinIcon class="ml-2 mr-1 h-4 w-4 rounded-sm" />Jellyfin <ChevronRight
			class="h-4 w-4"
		/>
	</a>
</div>
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
{:else}
	<Carousel.Root class="mx-auto w-full">
		<Carousel.Content>
			<Carousel.Item>
				<Card.Root class="bg-muted animate-pulse">
					<Card.Content class="flex h-96 min-h-96 items-end justify-start p-6"></Card.Content>
				</Card.Root>
			</Carousel.Item>
		</Carousel.Content>
		<Carousel.Previous />
		<Carousel.Next />
	</Carousel.Root>
{/if}
