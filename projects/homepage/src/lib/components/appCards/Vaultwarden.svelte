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
	description="Manage your passwords."
	href="https://passwords.{domain}"
	gradientColours={["#000000", "#333333", "#aaaaaa"]}
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
