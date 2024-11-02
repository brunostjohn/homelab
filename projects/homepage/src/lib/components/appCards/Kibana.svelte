<script lang="ts">
	import { AppCard } from "../app";
	import { KibanaIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Kibana"
	description="View logs and metrics."
	gradientColours={["#8b74ea", "#b099f7", "#cdaefa"]}
	href="https://kibana.{domain}"
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<KibanaIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
