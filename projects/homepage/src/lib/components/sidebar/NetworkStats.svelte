<script lang="ts">
	import { trpc } from "$lib/trpc";

	const networkStats = trpc()?.unifi.siteStats.createQuery();
</script>

<p class="mb-1 mt-4 text-base font-semibold text-muted-foreground">Network</p>
{#if $networkStats?.data}
	<p>{JSON.stringify($networkStats?.data)}</p>
{/if}
