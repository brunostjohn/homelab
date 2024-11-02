<script lang="ts">
	import { AppCard } from "../app";
	import { ITToolsIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="IT Tools"
	description="Tools for IT professionals."
	href="https://ittools.{domain}"
	gradientColours={["#053e64", "#05598a", "#047abb"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<ITToolsIcon class="" />
		</div>
	{/snippet}
</AppCard>
