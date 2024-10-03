<script lang="ts">
	import { ChevronUp } from "lucide-svelte";
	import { Skeleton } from "$lib/components/ui";
</script>

<button class="align-center flex items-center !outline-none !ring-0">
	<p class="text-muted-foreground mb-1 text-base font-semibold">Nodes</p>
	<ChevronUp class="ml-auto h-4 w-4 transition-all" />
</button>
<ul class="mt-1 flex flex-col gap-4">
	{#each Array.from({ length: 5 }) as _}
		<li>
			<div class="flex items-center gap-2">
				<span class="relative flex h-2 w-2">
					<span class="bg-muted relative inline-flex h-2 w-2 rounded-full"></span>
				</span>
				<Skeleton class="h-3 w-full" />
			</div>
		</li>
	{/each}
</ul>
