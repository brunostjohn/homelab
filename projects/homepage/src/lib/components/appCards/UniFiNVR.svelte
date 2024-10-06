<script lang="ts">
	import { AppCard } from "../app";
	import { AudiobookshelfIcon } from "../icons";
	import UniFiProtect from "../icons/UniFiProtect.svelte";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();
</script>

<AppCard
	name="UniFi NVR"
	description="Manage our security cameras."
	href="https://10.10.0.2"
	gradientColours={["#04265b", "#043ca0", "#0451c4"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<UniFiProtect class={className} />
	{/snippet}
</AppCard>
