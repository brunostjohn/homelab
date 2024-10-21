<script lang="ts">
	import { trpc } from "$lib/trpc";
	import { ChevronRight } from "lucide-svelte";
	import JellyseerrRequestCard from "./JellyseerrRequestCard.svelte";
	import JellyseerrRequestCardSkeleton from "./JellyseerrRequestCardSkeleton.svelte";
	import { JellyseerrIcon } from "../icons";
	import { onDestroy } from "svelte";
	import { createMediaStore } from "svelte-media-queries";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	const requests = trpc()?.jellyseerr.recentRequests.createQuery();

	const matches = createMediaStore("(min-width: 768px)");
	onDestroy(() => matches.destroy());
</script>

{#if $requests?.data && $requests.data.length > 0}
	<div class="align-center mb-2 mt-6 flex items-center">
		<h2 class="align-center flex items-center gap-2 text-base font-semibold md:text-xl">
			<div class="h-6 w-6 rounded-md bg-white p-1 md:h-8 md:w-8">
				<JellyseerrIcon class="h-full w-full" />
			</div>
			Your Recent Requests
		</h2>
		<a
			href="https://den.{domain}/requests"
			class="align-center text-muted-foreground hover:text-primary ml-auto flex items-center text-sm transition-all md:text-base"
		>
			View all <ChevronRight class="h-4 w-4" />
		</a>
	</div>
	<ul class="mt-1 grid grid-cols-1 gap-2 md:grid-cols-2" style="grid-auto-rows: 1fr;">
		{#each $matches ? $requests.data : $requests.data.splice(0, 3) as request}
			<JellyseerrRequestCard {request} {domain} />
		{/each}
	</ul>
{:else if !$requests?.data}
	<div class="align-center mb-2 mt-6 flex items-center">
		<h2 class="align-center flex items-center gap-2 text-xl font-semibold">
			<div class="h-8 w-8 rounded-md bg-white p-1">
				<JellyseerrIcon class="h-full w-full" />
			</div>
			Your Recent Requests
		</h2>
		<a
			href="https://den.{domain}/requests"
			class="align-center text-muted-foreground hover:text-primary ml-auto flex items-center transition-all"
		>
			View all <ChevronRight class="h-4 w-4" />
		</a>
	</div>
	<ul class="mt-1 grid grid-cols-1 gap-2 md:grid-cols-2" style="grid-auto-rows: 1fr;">
		{#each Array.from({ length: $matches ? 6 : 3 }) as i}
			<JellyseerrRequestCardSkeleton />
		{/each}
	</ul>
{/if}
