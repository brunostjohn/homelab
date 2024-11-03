<script lang="ts">
	import { ChevronLeft } from "lucide-svelte";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		showBackButton?: boolean;
	}

	const { children, showBackButton = false }: Props = $props();
</script>

{#if showBackButton}
	<a
		href="/"
		class="align-center text-muted-foreground hover:text-primary -ml-2 mb-1 flex w-max items-center text-sm transition-all md:text-base"
	>
		<ChevronLeft />Go back home
	</a>
{/if}
<h1 class="align-center mb-8 flex items-center gap-2 text-2xl font-semibold md:text-4xl">
	{@render children()}
</h1>
