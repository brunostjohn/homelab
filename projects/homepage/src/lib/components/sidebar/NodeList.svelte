<script lang="ts">
	import Node from "./Node.svelte";

	interface INode {
		name: string;
		ready: boolean;
		cpu: number;
		memory: number;
	}

	interface Props {
		nodes: INode[];
	}

	const { nodes }: Props = $props();
</script>

<p class="text-muted-foreground mb-1 text-base font-semibold">Nodes</p>
<ul class="flex flex-col gap-2">
	{#each nodes as node (node.name)}
		<Node {node} />
	{/each}
</ul>
