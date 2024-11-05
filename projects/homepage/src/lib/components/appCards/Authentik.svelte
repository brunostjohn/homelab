<script lang="ts">
	import { AppCard } from "../app";
	import { AuthentikIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Authentik"
	description="Identity & access management."
	href="https://auth.{domain}"
	gradientColours={["#fc5434", "#fc593e", "#fc6444"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<AuthentikIcon class="" />
		</div>
	{/snippet}
</AppCard>
