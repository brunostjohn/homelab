<script lang="ts">
	import { Card, Carousel } from "$lib/components/ui";
	import { trpc } from "$lib/trpc";
	import JellyfinRecentsCarouselItem from "./JellyfinRecentsCarouselItem.svelte";

	interface Props {
		serverPublicUrl: string;
	}

	const resumeItems = trpc()?.jellyfin.resume.createQuery();

	const { serverPublicUrl }: Props = $props();
</script>

<Carousel.Root>
	<Carousel.Content>
		{#if $resumeItems?.data}
			{#each $resumeItems?.data as item (item.Id)}
				<JellyfinRecentsCarouselItem {item} {serverPublicUrl} />
			{/each}
		{:else}
			{#each Array.from({ length: 7 }) as _}
				<Carousel.Item class="basis-1/4">
					<Card.Root class="bg-muted aspect-[3/4] animate-pulse"></Card.Root>
				</Carousel.Item>
			{/each}
		{/if}
	</Carousel.Content>
	<Carousel.Previous />
	<Carousel.Next />
</Carousel.Root>
