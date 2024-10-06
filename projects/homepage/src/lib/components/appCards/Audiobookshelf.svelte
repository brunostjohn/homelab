<script lang="ts">
	import { AppCard } from "../app";
	import { AudiobookshelfIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Audiobookshelf"
	description="Listen to audiobooks & podcasts."
	href="https://audiobookshelf.{domain}"
	gradientColours={["#8b622b", "#a07333", "#c89c53"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<AudiobookshelfIcon />
		</div>
	{/snippet}
</AppCard>
