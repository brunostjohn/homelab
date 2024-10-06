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
		"text-4xl font-semibold",
		titleIcon ? "align-center flex items-center gap-2" : "",
		className
	)}
>
	{#if titleIcon}
		{@render titleIcon("h-8 w-8")}
	{/if}
	{@render children()}
</h1>
