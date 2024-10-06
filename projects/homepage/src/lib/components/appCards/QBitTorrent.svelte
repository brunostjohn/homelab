<script lang="ts">
	import { AppCard } from "../app";
	import { QBitTorrentIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="QBitTorrent"
	description="Torrent client."
	gradientColours={["#407bc9", "#64a4ec", "#a2ccf4"]}
	href="https://fetching.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<QBitTorrentIcon class={className} />
	{/snippet}
</AppCard>
