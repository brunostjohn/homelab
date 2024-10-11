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
		class="align-center -ml-2 mb-1 flex items-center text-muted-foreground transition-all hover:text-primary"
	>
		<ChevronLeft />Go back home
	</a>
{/if}
<h1 class="align-center mb-8 flex items-center gap-2 text-4xl font-semibold">
	{@render children()}
</h1>
