<script lang="ts">
	import type { HTMLAttributes } from "svelte/elements";

	interface Props extends HTMLAttributes<HTMLImageElement> {}

	const { ...rest }: Props = $props();
</script>

<enhanced:img
	{...rest}
	src="$lib/assets/truenas-scale.webp"
	alt="TrueNAS Scale Logo"
	loading="lazy"
/>
