<script lang="ts">
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		icon: Snippet<[string]>;
		href: string;
	}

	const { children, icon, href }: Props = $props();
</script>

<li>
	<a
		{href}
		class="align-center text-muted-foreground hover:text-primary inline-flex items-center gap-2 transition-all"
	>
		{@render icon("h-5 w-5")}
		{@render children()}
	</a>
</li>
