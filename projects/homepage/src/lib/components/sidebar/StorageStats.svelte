<script lang="ts">
	import { trpc } from "$lib/trpc";
	import Pool from "./Pool.svelte";
	import PoolStatsSkeleton from "./PoolStatsSkeleton.svelte";

	const poolStats = trpc()?.trueNas.poolStats.createQuery();
</script>

<p class="text-muted-foreground mb-1 mt-4 text-base font-semibold">Storage</p>
{#if $poolStats?.data}
	{#each $poolStats.data as pool (pool.name)}
		<Pool {pool} />
	{/each}
{:else}
	<PoolStatsSkeleton />
{/if}
