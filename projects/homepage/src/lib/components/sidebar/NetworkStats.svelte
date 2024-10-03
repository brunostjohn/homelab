<script lang="ts">
	import { trpc } from "$lib/trpc";

	const networkStats = trpc()?.unifi.siteStats.createQuery();
</script>

<p class="text-muted-foreground mb-1 mt-4 text-base font-semibold">Network</p>
{#if $networkStats?.data}
	<p>{JSON.stringify($networkStats?.data)}</p>
{/if}
