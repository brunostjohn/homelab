<script lang="ts">
	import { cn } from "$lib/utils";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		onHome?: boolean;
		class?: string;
	}

	const { children, onHome, class: className }: Props = $props();
</script>

<h2
	class={cn(
		onHome
			? "align-center flex items-center gap-2 text-lg font-medium md:text-2xl"
			: "align-center mb-1 flex items-center gap-2 font-semibold md:mb-2 md:text-3xl",
		className
	)}
>
	{@render children()}
</h2>
