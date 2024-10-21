<script lang="ts">
	import { cn } from "$lib/utils";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		titleIcon?: Snippet<[string]>;
		class?: string;
	}

	const { children, titleIcon, class: className }: Props = $props();
</script>

<h1
	class={cn(
		"text-2xl font-semibold md:text-4xl",
		titleIcon ? "align-center flex items-center gap-2" : "",
		className
	)}
>
	{#if titleIcon}
		{@render titleIcon("md:h-8 md:w-8 h-6 w-6")}
	{/if}
	{@render children()}
</h1>
