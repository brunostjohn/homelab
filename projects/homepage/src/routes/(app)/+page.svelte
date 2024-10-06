<script lang="ts">
	import { JellyfinLatestCarousel } from "$lib/components/media";
	import { Button } from "$lib/components/ui";
	import type { PageServerData } from "./$types";
	import { AppCard } from "$lib/components/app";
	import { ChevronRight, Cloud } from "lucide-svelte";
	import {
		AudiobookshelfAppCard,
		ImmichAppCard,
		JellyfinAppCard,
		RommAppCard,
		VaultwardenAppCard,
		NextcloudAppCard,
	} from "$lib/components/appCards";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { publicJellyfinUrl, rootDomain: domain } = $derived(data);
</script>

<JellyfinLatestCarousel serverPublicUrl={publicJellyfinUrl} />

<section class="my-4">
	<h2 class="align-center flex items-center gap-2 text-2xl font-medium">Entertainment Apps</h2>

	<ul class="mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
		<JellyfinAppCard {domain} />

		<RommAppCard {domain} />

		<AudiobookshelfAppCard {domain} />

		<Button variant="ghost" class="group h-full gap-6" href="/entertainment">
			<div class="text-left">
				<p class="text-lg">See more apps</p>
				<p class="text-muted-foreground">Request media, check on your downloads.</p>
			</div>
			<ChevronRight class="h-6 w-6 transition-all group-hover:translate-x-1" />
		</Button>
	</ul>
</section>

<h1 class="align-center mt-8 flex items-center gap-2 text-4xl font-semibold">
	<Cloud class="h-8 w-8" />
	Recent Files
</h1>

<section class="my-4">
	<h2 class="align-center flex items-center gap-2 text-2xl font-medium">Personal Cloud Apps</h2>

	<ul class="mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
		<ImmichAppCard {domain} />

		<VaultwardenAppCard {domain} />

		<NextcloudAppCard {domain} />
	</ul>
</section>
