<script lang="ts">
	import { trpc } from "$lib/trpc";
	import { ChevronRight } from "lucide-svelte";
	import JellyseerrRequestCard from "./JellyseerrRequestCard.svelte";
	import JellyseerrRequestCardSkeleton from "./JellyseerrRequestCardSkeleton.svelte";
	import { JellyseerrIcon } from "../icons";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	const requests = trpc()?.jellyseerr.recentRequests.createQuery();
</script>

{#if $requests?.data && $requests.data.length > 0}
	<div class="align-center mb-2 mt-6 flex items-center">
		<h2 class="align-center flex items-center gap-2 text-xl font-semibold">
			<div class="h-8 w-8 rounded-md bg-white p-1">
				<JellyseerrIcon class="h-full w-full" />
			</div>
			Your Recent Requests
		</h2>
		<a
			href="https://den.{domain}/requests"
			class="align-center ml-auto flex items-center text-muted-foreground transition-all hover:text-primary"
		>
			View all <ChevronRight class="h-4 w-4" />
		</a>
	</div>
	<ul class="mt-1 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
		{#each $requests.data as request}
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
			class="align-center ml-auto flex items-center text-muted-foreground transition-all hover:text-primary"
		>
			View all <ChevronRight class="h-4 w-4" />
		</a>
	</div>
	<ul class="mt-1 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
		{#each Array.from({ length: 6 }) as i}
			<JellyseerrRequestCardSkeleton />
		{/each}
	</ul>
{/if}
