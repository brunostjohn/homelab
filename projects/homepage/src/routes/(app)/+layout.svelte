<script lang="ts">
	import { AppShell } from "$lib/components/app";
	import type { LayoutServerData } from "./$types";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		data: LayoutServerData;
	}

	const { data, children }: Props = $props();
	const { domain } = $derived(data);
</script>

<svelte:head>
	<title>Zefir&apos;s Cloud</title>
</svelte:head>

<AppShell {children} {domain} />
