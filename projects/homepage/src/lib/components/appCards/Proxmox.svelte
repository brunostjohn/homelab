<script lang="ts">
	import { MultiInstanceAppCard } from "../app";
	import { ProxmoxLogo } from "../icons";

	interface Props {
		notInList?: boolean;
		class?: string;
	}

	const { notInList, class: className }: Props = $props();

	const instances = [
		{ name: "S1", href: "https://10.0.0.11:8006" },
		{ name: "S2", href: "https://10.0.0.12:8006" },
		{ name: "S3", href: "https://10.0.0.13:8006" },
	];
</script>

<MultiInstanceAppCard
	name="Proxmox"
	description="Create and manage virtual machines."
	gradientColours={["#e46c04", "#e46c04", "#e38029"]}
	class={className}
	{instances}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<ProxmoxLogo class="" />
		</div>
	{/snippet}
</MultiInstanceAppCard>
