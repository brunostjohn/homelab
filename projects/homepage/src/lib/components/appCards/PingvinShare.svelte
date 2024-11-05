<script lang="ts">
	import { AppCard } from "../app";
	import { PingvinShareIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
		domain: string;
	}

	const { notInList, class: className, domain }: Props = $props();
</script>

<AppCard
	name="Pingvin Share"
	description="File sharing."
	href="https://share.{domain}"
	gradientColours={["#44539b", "#6067a1", "#6971b4"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<PingvinShareIcon class="" />
		</div>
	{/snippet}
</AppCard>
