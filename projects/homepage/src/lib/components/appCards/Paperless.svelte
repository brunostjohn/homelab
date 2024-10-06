<script lang="ts">
	import { AppCard } from "../app";
	import { PaperlessIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Paperless"
	description="Manage documents, categorise them."
	href="https://audiobookshelf.{domain}"
	gradientColours={["#1c541c", "#7c9a7c", "#819c84"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<PaperlessIcon />
		</div>
	{/snippet}
</AppCard>
