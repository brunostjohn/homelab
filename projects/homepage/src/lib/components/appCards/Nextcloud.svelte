<script lang="ts">
	import { AppCard } from "../app";
	import { NextcloudIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Nextcloud"
	description="Listen to audiobooks & podcasts."
	href="https://nextcloud.{domain}"
	gradientColours={["#8b622b", "#a07333", "#c89c53"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
		>
			<NextcloudIcon />
		</div>
	{/snippet}
</AppCard>
