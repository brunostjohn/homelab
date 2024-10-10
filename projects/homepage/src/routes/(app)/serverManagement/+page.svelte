<script lang="ts">
	import { PageTitle } from "$lib/components/app";
	import type { PageServerData } from "./$types";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { domain } = $derived(data);
</script>

<PageTitle showBackButton>Server Management</PageTitle>
