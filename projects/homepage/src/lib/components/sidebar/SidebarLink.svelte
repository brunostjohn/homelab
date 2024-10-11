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
		class="align-center inline-flex items-center gap-2 text-muted-foreground transition-all hover:text-primary"
	>
		{@render icon("h-5 w-5")}
		{@render children()}
	</a>
</li>
