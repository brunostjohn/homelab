<script lang="ts">
	import "../app.css";
	import { ModeWatcher } from "mode-watcher";
	import type { Snippet } from "svelte";
	import { QueryClient, QueryClientProvider } from "@tanstack/svelte-query";

	const queryClient = new QueryClient();

	interface Props {
		children: Snippet;
	}

	const { children }: Props = $props();
</script>

<QueryClientProvider client={queryClient}>
	<ModeWatcher />
	{@render children()}
</QueryClientProvider>
