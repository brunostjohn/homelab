<script lang="ts">
	import { Cpu, MemoryStick } from "lucide-svelte";

	interface Props {
		cpu: {
			percent: number;
		};
		memory: {
			percent: number;
		};
	}

	const { cpu, memory }: Props = $props();
	const cpuPercent = $derived(Math.round(cpu.percent * 10) / 10);
	const memoryPercent = $derived(Math.round(memory.percent * 10) / 10);
</script>

<p class="text-muted-foreground mb-1 text-base font-semibold">Resources</p>

<div class="mb-4 flex flex-col gap-2">
	<div class="flex items-center gap-2">
		<p
			class="text-muted-foreground align-center flex w-16 min-w-16 max-w-16 items-center gap-1 text-sm"
		>
			<Cpu class="h-4 w-4" />{cpuPercent}%
		</p>
		<div class="w-full">
			<div class="bg-muted h-2 w-full rounded-full">
				<div
					class="bg-muted-foreground h-full rounded-full transition-all"
					style="width: {cpuPercent}%;"
				></div>
			</div>
		</div>
	</div>
	<div class="flex items-center gap-2">
		<p
			class="text-muted-foreground align-center flex w-16 min-w-16 max-w-16 items-center gap-1 text-sm"
		>
			<MemoryStick class="h-4 w-4" />{memoryPercent}%
		</p>
		<div class="bg-muted h-2 w-full rounded-full">
			<div
				class="bg-muted-foreground h-full rounded-full transition-all"
				style="width: {memoryPercent}%;"
			></div>
		</div>
	</div>
</div>
