<script lang="ts">
	import { trpc } from "$lib/trpc";
	import JellyseerrRequestCard from "./JellyseerrRequestCard.svelte";
	import JellyseerrRequestCardSkeleton from "./JellyseerrRequestCardSkeleton.svelte";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	const requests = trpc()?.jellyseerr.recentRequests.createQuery();
</script>

<ul class="mt-1 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
	{#if $requests?.data}
		{#each $requests.data as request}
			<JellyseerrRequestCard {request} {domain} />
		{/each}
	{:else}
		{#each Array.from({ length: 6 }) as i}
			<JellyseerrRequestCardSkeleton />
		{/each}
	{/if}
</ul>
