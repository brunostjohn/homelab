<script lang="ts">
	import { Carousel, Card } from "$lib/components/ui";
	import { Timer } from "lucide-svelte";

	interface Recipe {
		id: string;
		name: string;
		slug: string;
		image?: string;
		groupSlug: string;
		totalTime?: string | null;
		description?: string | null;
	}

	interface Props {
		domain: string;
		recipe: Recipe;
	}

	const { domain, recipe }: Props = $props();
	const { name, slug, image, totalTime, description, groupSlug } = $derived(recipe);

	let imageFailedToLoad = $state(false);
	let backgroundFailedToLoad = $state(false);
</script>

<Carousel.Item class="basis-1/3">
	<a href="https://mealie.{domain}/g/{groupSlug}/r/{slug}" class="group contents">
		<Card.Root
			class="group-hover:border-muted-foreground relative max-h-72 min-h-72 overflow-hidden transition-all"
		>
			{#if !backgroundFailedToLoad}
				<img
					src={image}
					alt={`Image of ${name}`}
					class="absolute left-0 top-0 z-0 h-full w-full object-cover blur-xl brightness-[20%] saturate-150 transition-all group-hover:brightness-[25%] group-hover:saturate-200"
					onerror={() => (backgroundFailedToLoad = true)}
				/>
			{/if}
			<div class="relative">
				{#if !imageFailedToLoad}
					<img
						src={image}
						alt={`Image of ${name}`}
						class="h-32 w-full object-cover transition-all group-hover:h-28"
						onerror={() => (imageFailedToLoad = true)}
					/>
				{/if}
				<div class="p-4">
					{#if totalTime}
						<p
							class="align-center text-muted-foreground mb-1 flex items-center gap-1 text-xs font-semibold uppercase"
						>
							<Timer class="h-4 w-4" />
							{totalTime}
						</p>
					{/if}
					<p class="mb-2 font-semibold leading-tight">{name}</p>
					{#if description}
						<p class="text-muted-foreground line-clamp-3 overflow-hidden text-ellipsis text-sm">
							{description}
						</p>
					{/if}
				</div>
			</div>
		</Card.Root>
	</a>
</Carousel.Item>
