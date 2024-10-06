<script lang="ts">
	import { AppCard } from "../app";
	import { VaultwardenIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Vaultwarden"
	description="Collect & download game console roms."
	href="https://passwords.{domain}"
	gradientColours={["#4200d0", "#7200df", "#ce00fb"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center flex aspect-square items-center justify-center bg-white p-1 {className}"
		>
			<VaultwardenIcon />
		</div>
	{/snippet}
</AppCard>
