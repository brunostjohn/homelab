<script lang="ts">
	import { trpc } from "$lib/trpc";
	import { onDestroy } from "svelte";
	import { createMediaStore } from "svelte-media-queries";
	import { Card } from "../ui";
	import AnimatedGradient from "./AnimatedGradient.svelte";
	import RecentChat from "./RecentChat.svelte";
	import SeeMoreChats from "./SeeMoreChats.svelte";
	import ChatSkeleton from "./ChatSkeleton.svelte";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	const chatsQuery = trpc()?.openwebui.recentConversations.createQuery();

	const matches = createMediaStore("(min-width: 768px)");
	onDestroy(() => matches.destroy());
</script>

<Card.Root
	class="relative mb-2 grid grid-cols-1 overflow-hidden md:grid-cols-2"
	style="grid-auto-rows: 1fr;"
>
	<AnimatedGradient class="absolute left-0 top-0 z-0 h-full w-full brightness-[50%]" />

	{#if $chatsQuery?.data}
		{#each $chatsQuery.data.slice(0, $matches ? 5 : 2) as chat, i (chat.id)}
			<RecentChat {domain} {chat} {i} count={$chatsQuery.data.length} />
		{/each}
		{#if ($matches && $chatsQuery.data.length > 4) || (!$matches && $chatsQuery.data.length > 1)}
			<SeeMoreChats {domain} />
		{/if}
	{:else}
		{#each Array.from({ length: $matches ? 6 : 3 }) as _, i}
			<ChatSkeleton {i} count={$matches ? 6 : 3} />
		{/each}
	{/if}
</Card.Root>
