<script lang="ts">
	import { AppCard } from "../app";
	import { StirlingPDFIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="PDF Tools"
	description="Convert, merge, split, and more."
	href="https://pdftools.{domain}"
	gradientColours={["#053e64", "#05598a", "#047abb"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<StirlingPDFIcon class="" />
		</div>
	{/snippet}
</AppCard>
