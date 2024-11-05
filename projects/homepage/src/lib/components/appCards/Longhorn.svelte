<script lang="ts">
	import { AppCard } from "../app";
	import { LonghornIcon } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Longhorn"
	description="Cloud-native distributed block storage."
	href="http://10.0.2.9/"
	gradientColours={["#743c64", "#794866", "#84536c"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<LonghornIcon class="" />
		</div>
	{/snippet}
</AppCard>
