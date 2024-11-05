<script lang="ts">
	import { AppCard } from "../app";
	import { PlaneIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Plane"
	description="Project management & robust to-do."
	href="https://plane.{domain}"
	gradientColours={["#3c74fc", "#4474fc", "#4c7efc"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-2 {className}"
		>
			<PlaneIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
