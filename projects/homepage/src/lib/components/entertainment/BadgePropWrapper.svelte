<script lang="ts">
	import { Badge } from "$lib/components/ui";
	import type { ComponentProps } from "svelte";

	interface Props extends ComponentProps<Badge> {
		text: string;
	}

	const { text, ...badgeProps }: Props = $props();
</script>

<Badge {...badgeProps}>{text}</Badge>
