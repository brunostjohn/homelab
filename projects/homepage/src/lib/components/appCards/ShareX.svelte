<script lang="ts">
	import { AppCard } from "../app";
	import { ShareXIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
		domain: string;
	}

	const { notInList, class: className, domain }: Props = $props();
</script>

<AppCard
	name="Zipline"
	description="ShareX file sharing."
	href="https://iam.{domain}"
	gradientColours={["#053e64", "#05598a", "#047abb"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<ShareXIcon class="" />
		</div>
	{/snippet}
</AppCard>
