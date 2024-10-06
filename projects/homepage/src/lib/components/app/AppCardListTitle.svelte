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
			? "align-center flex items-center gap-2 text-2xl font-medium"
			: "align-center mb-2 flex items-center gap-2 text-3xl font-semibold",
		className
	)}
>
	{@render children()}
</h2>
