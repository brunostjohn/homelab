<script lang="ts">
	import { AppCard } from "../app";
	import { RallyIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Rally"
	description="Schedule events with ease."
	href="https://rally.{domain}"
	gradientColours={["#6464f4", "#6c64f8", "#6c64f8"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<RallyIcon class="" />
		</div>
	{/snippet}
</AppCard>
