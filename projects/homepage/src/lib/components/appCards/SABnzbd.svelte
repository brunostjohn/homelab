<script lang="ts">
	import { AppCard } from "../app";
	import { SABnzbdIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="SABnzbd"
	description="Usenet client."
	gradientColours={["#8c620c", "#b6810b", "#fbc116"]}
	href="https://sabnzbd.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-[8px] bg-white p-1 {className}">
			<SABnzbdIcon class="relative h-full w-full" />
		</div>
	{/snippet}
</AppCard>
