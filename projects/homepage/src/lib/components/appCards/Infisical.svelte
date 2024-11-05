<script lang="ts">
	import { AppCard } from "../app";
	import { InfisicalIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
		domain: string;
	}

	const { notInList, class: className, domain }: Props = $props();
</script>

<AppCard
	name="Infisical"
	description="Secrets management."
	href="https://secrets.{domain}"
	gradientColours={["#c6d14c", "#bbcc48", "#b3bd45"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center overflow-hidden bg-white {className}"
		>
			<InfisicalIcon class="" />
		</div>
	{/snippet}
</AppCard>
