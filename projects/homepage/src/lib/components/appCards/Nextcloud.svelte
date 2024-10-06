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
	gradientColours={["#053e64", "#05598a", "#047abb"]}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center jusitfy-center flex aspect-square items-center bg-[#17a6f4] p-1 {className}"
		>
			<NextcloudIcon class="" />
		</div>
	{/snippet}
</AppCard>
