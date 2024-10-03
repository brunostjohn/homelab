<script lang="ts">
	import { JellyfinLatestCarousel } from "$lib/components/media";
	import type { PageServerData } from "./$types";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { publicJellyfinUrl } = $derived(data);
</script>

<JellyfinLatestCarousel serverPublicUrl={publicJellyfinUrl} />
