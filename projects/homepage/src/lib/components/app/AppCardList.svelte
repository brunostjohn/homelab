<script lang="ts">
	import type { Snippet } from "svelte";
	import AppCardListTitle from "./AppCardListTitle.svelte";
	import { cn } from "$lib/utils";

	interface Props {
		title?: string;
		children: Snippet;
		onHome?: boolean;
		class?: string;
		titleClass?: string;
	}

	const { title, children, onHome, class: className, titleClass }: Props = $props();
</script>

{#if title}
	<AppCardListTitle {onHome} class={titleClass}>
		{title}
	</AppCardListTitle>
{/if}
<ul
	class={cn("mb-4 mt-2 grid grid-cols-1 gap-2 sm:grid-cols-2 xl:mb-8", className)}
	style="grid-auto-rows: 1fr;"
>
	{@render children()}
</ul>
