<script lang="ts">
	import { Card, Carousel } from "$lib/components/ui";
	import { trpc } from "$lib/trpc";
	import { ChevronRight } from "lucide-svelte";
	import { JellyfinIcon } from "../icons";
	import JellyfinRecentsCarouselItem from "./JellyfinRecentsCarouselItem.svelte";
	import { onDestroy } from "svelte";
	import { createMediaStore } from "svelte-media-queries";

	interface Props {
		domain: string;
	}

	const resumeItems = trpc()?.jellyfin.resume.createQuery();

	const { domain }: Props = $props();

	const matches = createMediaStore("(min-width: 768px)");
	onDestroy(() => matches.destroy());
</script>

{#if $resumeItems?.data && $resumeItems.data.length > 0}
	<div class="align-center mb-2 flex items-center">
		<h2 class="align-center flex items-center gap-2 text-base font-semibold md:text-xl">
			<JellyfinIcon class="h-6 w-6 rounded-md md:h-8 md:w-8" />Continue Watching
		</h2>
		<a
			href="https://birds.{domain}"
			class="align-center text-muted-foreground hover:text-primary ml-auto flex items-center text-sm transition-all md:text-base"
		>
			View all <ChevronRight class="h-4 w-4" />
		</a>
	</div>
	<Carousel.Root>
		<Carousel.Content>
			{#each $resumeItems?.data as item (item.Id)}
				<JellyfinRecentsCarouselItem {item} {domain} />
			{/each}
		</Carousel.Content>
		{#if $matches}
			<Carousel.Previous />
			<Carousel.Next />
		{/if}
	</Carousel.Root>
{:else if !$resumeItems?.data}
	<div class="align-center mb-2 flex items-center">
		<h2 class="align-center flex items-center gap-2 text-xl font-semibold">
			<JellyfinIcon class="h-8 w-8 rounded-md" />Continue Watching
		</h2>
		<a
			href="https://birds.{domain}"
			class="align-center text-muted-foreground hover:text-primary ml-auto flex items-center transition-all"
		>
			View all <ChevronRight class="h-4 w-4" />
		</a>
	</div>
	<Carousel.Root>
		<Carousel.Content>
			{#each Array.from({ length: 7 }) as _}
				<Carousel.Item class="basis-1/3 sm:basis-1/4">
					<Card.Root class="bg-muted aspect-[3/4] animate-pulse"></Card.Root>
				</Carousel.Item>
			{/each}
		</Carousel.Content>
		{#if $matches}
			<Carousel.Previous />
			<Carousel.Next />
		{/if}
	</Carousel.Root>
{/if}
