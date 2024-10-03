<script lang="ts">
	import { trpc } from "$lib/trpc";
	import KubeResourceUsage from "./KubeResourceUsage.svelte";
	import KubeResourceUsageSkeleton from "./KubeResourceUsageSkeleton.svelte";
	import NodeList from "./NodeList.svelte";
	import NodeListSkeleton from "./NodeListSkeleton.svelte";

	const kubeStats = trpc()?.kube.metrics.createQuery(undefined, {
		refetchInterval: 1000,
	});
</script>

{#if $kubeStats?.data}
	<KubeResourceUsage cpu={$kubeStats.data.cpu} memory={$kubeStats.data.memory} />
	<NodeList
		nodes={$kubeStats.data.nodes.map(
			({ name, cpu: { total: cpu }, memory: { total: memory }, ready }) => ({
				name,
				cpu,
				memory,
				ready,
			})
		)}
	/>
{:else}
	<KubeResourceUsageSkeleton />
	<NodeListSkeleton />
{/if}
