<script lang="ts">
	import { AppCard } from "../app";
	import { NocoDBIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="NocoDB"
	description="Airtable alternative."
	href="https://noco.{domain}"
	gradientColours={["#3330bd", "#3c3ecf", "#4049df"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<NocoDBIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
