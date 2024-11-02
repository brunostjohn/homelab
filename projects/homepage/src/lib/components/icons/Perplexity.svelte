<script lang="ts">
	import type { HTMLAttributes } from "svelte/elements";

	interface Props extends HTMLAttributes<HTMLImageElement> {}

	const { ...rest }: Props = $props();
</script>

<enhanced:img {...rest} src="$lib/assets/perplexity.webp" alt="Perplexity Logo" loading="lazy" />
