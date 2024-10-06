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
	name="Ollama"
	description="Talk to LLMs, run custom tools."
	href="https://ollama.{domain}"
	gradientColours={["#053e64", "#05598a", "#047abb"]}
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
