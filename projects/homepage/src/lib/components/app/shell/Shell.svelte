<script lang="ts">
	import { onDestroy, type Snippet } from "svelte";
	import { createMediaStore } from "svelte-media-queries";
	import Large from "./Large.svelte";
	import Medium from "./Medium.svelte";

	interface Props {
		children: Snippet;
		domain: string;
	}

	const { children, domain }: Props = $props();

	const matches = createMediaStore("(min-width: 1280px)");
	onDestroy(() => matches.destroy());
</script>

{#if $matches}
	<Large {children} {domain} />
{:else}
	<Medium {children} {domain} />
{/if}
