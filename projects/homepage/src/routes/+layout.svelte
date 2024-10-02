<script lang="ts">
	import "../app.css";
	import { ModeWatcher } from "mode-watcher";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
	}

	const { children }: Props = $props();
</script>

<ModeWatcher />
{@render children()}
