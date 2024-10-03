<script lang="ts">
	import { cn } from "$lib/utils";
	import { Tooltip } from "$lib/components";
	import { filesize } from "filesize";
	import { Cpu, MemoryStick } from "lucide-svelte";
	import { fly } from "svelte/transition";

	interface Node {
		name: string;
		ready: boolean;
		cpu: number;
		memory: number;
	}

	interface Props {
		node: Node;
		expanded: boolean;
	}

	const { node, expanded }: Props = $props();
</script>

<li>
	<div class="flex items-center gap-2">
		<Tooltip.Root>
			<Tooltip.Trigger asChild let:builder>
				<span class="relative flex h-2 w-2" {...builder} use:builder.action>
					{#if node.ready}
						<span
							class="absolute inline-flex h-full w-full animate-ping rounded-full bg-green-400 opacity-75"
						></span>
					{/if}
					<span
						class={cn(
							"relative inline-flex h-2 w-2 rounded-full",
							node.ready ? "bg-green-500" : "bg-red-500"
						)}
					></span>
				</span>
			</Tooltip.Trigger>
			<Tooltip.Content>Node is {node.ready ? "Ready" : "NotReady"}.</Tooltip.Content>
		</Tooltip.Root>

		<p class="text-sm font-semibold">{node.name}</p>
	</div>

	{#if expanded}
		<div class="flex items-center gap-4" transition:fly={{ y: -5 }}>
			<p class="text-muted-foreground align-center inline-flex items-center gap-1 text-sm">
				<Cpu class="h-4 w-4" />{node.cpu}
			</p>
			<p class="text-muted-foreground align-center inline-flex items-center gap-1 text-sm">
				<MemoryStick class="h-4 w-4" />{filesize(node.memory)}
			</p>
		</div>
	{/if}
</li>
