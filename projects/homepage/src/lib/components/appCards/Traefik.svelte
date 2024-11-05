<script lang="ts">
	import { AppCard } from "../app";
	import { TraefikIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Traefik"
	description="Reverse proxy & load balancer."
	href="https://10.0.2.0/dashboard/"
	gradientColours={["#3ca4c4", "#28a4c4", "#28a4c4"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<TraefikIcon class="" />
		</div>
	{/snippet}
</AppCard>
