<script lang="ts">
	import { trpc } from "$lib/trpc";
	import Pool from "./Pool.svelte";
	import PoolStatsSkeleton from "./PoolStatsSkeleton.svelte";

	const poolStats = trpc()?.trueNas.poolStats.createQuery();
</script>

<p class="mb-1 mt-4 text-base font-semibold text-muted-foreground">Storage</p>
{#if $poolStats?.data}
	{#each $poolStats.data as pool (pool.name)}
		<Pool {pool} />
	{/each}
{:else}
	<PoolStatsSkeleton />
{/if}
