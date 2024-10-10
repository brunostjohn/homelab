<script lang="ts">
	import { trpc } from "$lib/trpc";
	import { Card } from "../ui";
	import AnimatedGradient from "./AnimatedGradient.svelte";
	import RecentChat from "./RecentChat.svelte";
	import SeeMoreChats from "./SeeMoreChats.svelte";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	const chatsQuery = trpc()?.openwebui.recentConversations.createQuery();
</script>

<Card.Root class="relative mb-2 grid grid-cols-2 overflow-hidden" style="grid-auto-rows: 1fr;">
	<AnimatedGradient class="absolute left-0 top-0 z-0 h-full w-full brightness-[50%]" />
	{#if $chatsQuery?.data}
		{#each $chatsQuery.data.slice(0, 5) as chat, i (chat.id)}
			<RecentChat {domain} {chat} {i} count={$chatsQuery.data.length} />
		{/each}
		{#if $chatsQuery.data.length > 4}
			<SeeMoreChats {domain} />
		{/if}
	{/if}
</Card.Root>
