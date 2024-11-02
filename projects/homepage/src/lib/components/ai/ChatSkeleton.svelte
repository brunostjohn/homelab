<script lang="ts">
	import { cn } from "$lib/utils";
	import Skeleton from "../ui/skeleton/skeleton.svelte";

	interface Props {
		i: number;
		count: number;
	}

	const { i, count }: Props = $props();

	const isOdd = $derived(i % 2 === 0);
	const isFirstRow = $derived(i === 0 || i === 1);
	const isLastRow = $derived(i === count - 1 || (i === count - 2 && count % 2 === 0));
</script>

<div
	class={cn(
		"relative flex gap-2 p-3 backdrop-blur-lg backdrop-brightness-[25%] backdrop-saturate-150 md:p-4",
		"group-hover:bg-muted/30 border-muted-foreground/20 transition-all group-hover:backdrop-brightness-[60%]",
		"backdrop-grayscale",
		isFirstRow && isOdd ? "rounded-tl-md" : "",
		isFirstRow && !isOdd ? "rounded-tr-md" : "",
		isLastRow && isOdd ? "rounded-bl-md" : "",
		isLastRow && !isOdd ? "rounded-br-md" : ""
	)}
>
	<div class="overflow-hidden">
		<Skeleton class="mb-2 h-3 w-12" />
		<Skeleton class="mb-2 h-4 w-64" />
		<div class="align-center text-muted-foreground flex items-center gap-1">
			<Skeleton class="h-3 w-12" />
			<p class="w-fit text-nowrap text-xs font-semibold">:</p>
			<Skeleton class="h-3 w-24" />
		</div>
	</div>
</div>
