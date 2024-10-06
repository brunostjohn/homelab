<script lang="ts">
	import type { Snippet } from "svelte";
	import AppCardListTitle from "./AppCardListTitle.svelte";
	import { cn } from "$lib/utils";

	interface Props {
		title?: string;
		children: Snippet;
		onHome?: boolean;
		class?: string;
	}

	const { title, children, onHome, class: className }: Props = $props();
</script>

{#if title}
	<AppCardListTitle {onHome}>
		{title}
	</AppCardListTitle>
{/if}
<ul class={cn("mb-4 mt-2 grid grid-cols-2 gap-2", className)} style="grid-auto-rows: 1fr;">
	{@render children()}
</ul>
