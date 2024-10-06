<script lang="ts">
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		onHome?: boolean;
	}

	const { children, onHome }: Props = $props();
</script>

<h2
	class={onHome
		? "align-center flex items-center gap-2 text-2xl font-medium"
		: "align-center mb-2 flex items-center gap-2 text-3xl font-semibold"}
>
	{@render children()}
</h2>
