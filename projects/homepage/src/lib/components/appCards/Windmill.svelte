<script lang="ts">
	import { AppCard } from "../app";
	import { WindmillIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Windmill"
	description="Create apps & automations."
	href="https://windmill.{domain}"
	gradientColours={["#3c84f4", "#4484f4", "#4e8cf4"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<WindmillIcon class="" />
		</div>
	{/snippet}
</AppCard>
