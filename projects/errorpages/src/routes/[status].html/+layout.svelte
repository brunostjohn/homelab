<script lang="ts">
	import "./+layout.css";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
	}

	const { children }: Props = $props();
</script>

<main>
	<div aria-hidden="true" class="bgDiv"></div>
	{@render children()}
</main>

<style>
	main {
		height: 100vh;
		width: 100vw;
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
	}

	.bgDiv {
		position: absolute;
		inset: 0;
		z-index: -10;
		height: 100%;
		width: 100%;
		background: radial-gradient(125% 125% at 50% 10%, #000 40%, #63e 100%);
	}
</style>
