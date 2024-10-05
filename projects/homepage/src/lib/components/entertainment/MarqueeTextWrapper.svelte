<script lang="ts">
	import MarqueeTextWidget from "svelte-marquee-text-widget";

	interface Props {
		text: string;
	}

	const { text }: Props = $props();

	let hovering = $state(false);
</script>

<!-- svelte-ignore a11y_no_static_element_interactions -->
<!-- svelte-ignore a11y_mouse_events_have_key_events -->
<div
	class="max-w-52 overflow-hidden"
	onmouseenter={() => (hovering = true)}
	onmouseleave={() => (hovering = false)}
	onmouseout={() => (hovering = false)}
>
	<div class="w-full">
		{#if hovering}
			<MarqueeTextWidget>
				{text}
			</MarqueeTextWidget>
		{:else}
			<span class="max-w-full text-ellipsis whitespace-nowrap">{text}</span>
		{/if}
	</div>
</div>
