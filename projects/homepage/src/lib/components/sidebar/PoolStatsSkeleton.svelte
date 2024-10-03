<script lang="ts">
	import { Skeleton } from "$lib/components/ui";
	import { HardDrive } from "lucide-svelte";
</script>

{#each Array.from({ length: 3 }) as _}
	<Skeleton class="mb-1 h-3 w-16" />
	<Skeleton class="mb-1 h-2 w-full rounded-full" />
	<div class="text-muted-foreground align-center mb-2 flex items-center gap-1 text-xs">
		<HardDrive class="h-3 w-3" /><Skeleton class="h-3 w-8" />
		<Skeleton class="h-3 w-3" />/ <Skeleton class="h-3 w-8" />
		<Skeleton class="h-3 w-3" />
	</div>
{/each}
