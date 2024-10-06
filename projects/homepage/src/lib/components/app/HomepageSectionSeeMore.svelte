<script lang="ts">
	import { ChevronRight } from "lucide-svelte";
	import type { Snippet } from "svelte";

	interface Props {
		href: string;
		seeMoreIcon: Snippet<[string]>;
		seeMoreAppName: string;
	}

	const { href, seeMoreIcon, seeMoreAppName }: Props = $props();
</script>

<a
	{href}
	target="_blank"
	class="align-center text-muted-foreground hover:text-primary ml-auto flex items-center text-sm transition-all"
>
	See more on {@render seeMoreIcon("ml-2 mr-1 h-4 w-4")}{seeMoreAppName}
	<ChevronRight class="h-4 w-4" />
</a>
