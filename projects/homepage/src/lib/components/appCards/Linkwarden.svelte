<script lang="ts">
	import { AppCard } from "../app";
	import { LinkwardenIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Linkwarden"
	description="Link manager & collector."
	gradientColours={["#06141c", "#0c324a", "#124969"]}
	href="https://link.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<LinkwardenIcon class="rounded-md {className}" />
	{/snippet}
</AppCard>
