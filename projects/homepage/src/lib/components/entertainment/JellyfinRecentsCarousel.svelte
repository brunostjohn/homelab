<script lang="ts">
	import { Card, Carousel } from "$lib/components/ui";
	import { trpc } from "$lib/trpc";
	import { ChevronRight } from "lucide-svelte";
	import { JellyfinIcon } from "../icons";
	import JellyfinRecentsCarouselItem from "./JellyfinRecentsCarouselItem.svelte";

	interface Props {
		domain: string;
	}

	const resumeItems = trpc()?.jellyfin.resume.createQuery();

	const { domain }: Props = $props();
</script>

{#if $resumeItems?.data && $resumeItems.data.length > 0}
	<div class="align-center mb-2 flex items-center">
		<h2 class="align-center flex items-center gap-2 text-xl font-semibold">
			<JellyfinIcon class="h-8 w-8 rounded-md" />Continue Watching
		</h2>
		<a
			href="https://birds.{domain}"
			class="align-center ml-auto flex items-center text-muted-foreground transition-all hover:text-primary"
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
		<Carousel.Previous />
		<Carousel.Next />
	</Carousel.Root>
{:else if !$resumeItems?.data}
	<div class="align-center mb-2 flex items-center">
		<h2 class="align-center flex items-center gap-2 text-xl font-semibold">
			<JellyfinIcon class="h-8 w-8 rounded-md" />Continue Watching
		</h2>
		<a
			href="https://birds.{domain}"
			class="align-center ml-auto flex items-center text-muted-foreground transition-all hover:text-primary"
		>
			View all <ChevronRight class="h-4 w-4" />
		</a>
	</div>
	<Carousel.Root>
		<Carousel.Content>
			{#each Array.from({ length: 7 }) as _}
				<Carousel.Item class="basis-1/4">
					<Card.Root class="aspect-[3/4] animate-pulse bg-muted"></Card.Root>
				</Carousel.Item>
			{/each}
		</Carousel.Content>
		<Carousel.Previous />
		<Carousel.Next />
	</Carousel.Root>
{/if}
