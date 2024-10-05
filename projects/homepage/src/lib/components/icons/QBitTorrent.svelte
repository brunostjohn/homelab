<script lang="ts">
	import type { HTMLImgAttributes } from "svelte/elements";

	interface Props extends HTMLImgAttributes {}

	const { ...rest }: Props = $props();
</script>

<img
	{...rest}
	src="https://raw.githubusercontent.com/qbittorrent/qBittorrent/refs/heads/master/src/icons/qbittorrent_mac.svg"
	alt="qBittorrent Logo"
/>
