<script lang="ts">
	import { Skeleton } from "$lib/components/ui";
	import { Cpu, MemoryStick } from "lucide-svelte";
</script>

<p class="text-muted-foreground mb-1 text-base font-semibold">Resources</p>

<div class="mb-4 flex flex-col gap-3">
	<div class="flex items-center gap-2">
		<div
			class="text-muted-foreground align-center flex w-16 min-w-16 max-w-16 items-center gap-1 text-sm"
		>
			<Cpu class="h-4 w-4" /><Skeleton class="h-4 w-10" />
		</div>
		<div class="w-full">
			<Skeleton class="h-2 w-full rounded-full" />
		</div>
	</div>
	<div class="flex items-center gap-2">
		<div
			class="text-muted-foreground align-center flex w-16 min-w-16 max-w-16 items-center gap-1 text-sm"
		>
			<MemoryStick class="h-4 w-4" /><Skeleton class="h-4 w-10" />
		</div>
		<Skeleton class="h-2 w-full rounded-full" />
	</div>
</div>
