<script lang="ts">
	import { trpc } from "$lib/trpc";
	import InProgressDownloadsTable from "./InProgressDownloadsTable.svelte";

	const downloads = trpc()?.downloadClients.getActiveDownloads.createQuery();
</script>

{#if $downloads?.data}
	<InProgressDownloadsTable downloads={$downloads.data} />
{/if}
