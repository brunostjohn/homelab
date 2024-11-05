<script lang="ts">
	import { AppCard } from "../app";
	import { NextcloudIcon, OpenWebUIIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Chat"
	description="Talk to LLMs, run custom tools."
	href="https://chat.{domain}"
	gradientColours={["#4f4f4f", "#2f2f2f", "#1f1f1f"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<OpenWebUIIcon class="" />
		</div>
	{/snippet}
</AppCard>
