<script lang="ts">
	import { Carousel, Card, Skeleton } from "$lib/components/ui";
	import { Timer } from "lucide-svelte";
</script>

<Carousel.Item class="basis-1/3">
	<Card.Root class="max-h-72 min-h-72 overflow-hidden">
		<div class="bg-muted h-32 w-full animate-pulse" aria-hidden="true"></div>
		<div class="p-4">
			<div class="align-center mb-2 flex items-center gap-1">
				<Timer class="h-4 w-4" /><Skeleton class="h-3 w-4" />
			</div>

			<Skeleton class="mb-2 h-4 w-44" />
			<div class="flex flex-col gap-1">
				<Skeleton class="h-3 w-full" />
				<Skeleton class="h-3 w-[80%]" />
				<Skeleton class="h-3 w-[90%]" />
				<Skeleton class="h-3 w-[70%]" />
				<Skeleton class="h-3 w-[90%]" />
			</div>
		</div>
	</Card.Root>
</Carousel.Item>
