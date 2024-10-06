<script lang="ts">
	import { AppCard } from "../app";
	import { RommIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Romm"
	description="Collect & download game console roms."
	href="https://romm.{domain}"
	gradientColours={["#4200d0", "#7200df", "#ce00fb"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="aspect-square bg-white p-1 {className}">
			<RommIcon />
		</div>
	{/snippet}
</AppCard>
