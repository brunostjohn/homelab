<script lang="ts">
	import { AppCard } from "../app";
	import { SearXNGIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Search"
	description="Search the internet."
	href="https://search.{domain}"
	gradientColours={["#053e64", "#05598a", "#047abb"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<SearXNGIcon class="" />
		</div>
	{/snippet}
</AppCard>
