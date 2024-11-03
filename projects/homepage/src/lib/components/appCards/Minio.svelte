<script lang="ts">
	import { AppCard } from "../app";
	import { MinioIcon } from "../icons";

	interface Props {
		domain: string;
		notInList?: boolean;
		class?: string;
	}

	const { domain, notInList, class: className }: Props = $props();
</script>

<AppCard
	name="Minio"
	description="Manage object storage."
	gradientColours={["#c42c4c", "#de8494", "#dc8c94"]}
	href={`https://window.${domain}`}
	class={className}
	{notInList}
>
	{#snippet icon(className: string)}
		<div
			class="align-center flex aspect-square items-center justify-center bg-white p-1 {className}"
		>
			<MinioIcon />
		</div>
	{/snippet}
</AppCard>
