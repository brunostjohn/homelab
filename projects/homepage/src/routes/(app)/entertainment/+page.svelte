<script lang="ts">
	import { ChevronLeft, ChevronRight } from "lucide-svelte";
	import type { PageServerData } from "./$types";
	import { AppCard } from "$lib/components/app";
	import {
		AudiobookshelfIcon,
		JellyfinIcon,
		JellyseerrIcon,
		RommIcon,
	} from "$lib/components/icons";
	import { JellyfinRecentsCarousel, JellyseerrRequests } from "$lib/components/entertainment";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { domain } = $derived(data);
</script>

<a
	href="/"
	class="align-center text-muted-foreground hover:text-primary -ml-2 mb-1 flex items-center transition-all"
>
	<ChevronLeft />Go back home
</a>
<h1 class="align-center mb-6 flex items-center gap-2 text-4xl font-semibold">Entertainment</h1>

<h2 class="text-3xl font-semibold">Watch Media</h2>
<ul class="mb-4 mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
	<AppCard
		name="Jellyfin"
		description="Watch movies & shows, listen to music, and more."
		gradientColours={["#020b23", "#1f52aa", "#226e80"]}
		href="https://birds.{domain}"
	>
		{#snippet icon(className: string)}
			<JellyfinIcon class={className} />
		{/snippet}
	</AppCard>

	<AppCard
		name="Romm"
		description="Collect & download game console roms."
		href="https://romm.{domain}"
		gradientColours={["#4200d0", "#7200df", "#ce00fb"]}
	>
		{#snippet icon(className: string)}
			<div class="aspect-square bg-white p-1 {className}">
				<RommIcon />
			</div>
		{/snippet}
	</AppCard>

	<AppCard
		name="Audiobookshelf"
		description="Listen to audiobooks & podcasts."
		href="https://audiobookshelf.{domain}"
		gradientColours={["#8b622b", "#a07333", "#c89c53"]}
	>
		{#snippet icon(className: string)}
			<div class="aspect-square bg-white p-1 {className}">
				<AudiobookshelfIcon />
			</div>
		{/snippet}
	</AppCard>
</ul>

<div class="align-center mb-2 flex items-center">
	<h2 class="align-center flex items-center gap-2 text-xl font-semibold">
		<JellyfinIcon class="h-8 w-8 rounded-md" />Continue Watching
	</h2>
	<a
		href="https://birds.{domain}"
		class="align-center text-muted-foreground hover:text-primary ml-auto flex items-center transition-all"
	>
		View all <ChevronRight class="h-4 w-4" />
	</a>
</div>
<JellyfinRecentsCarousel serverPublicUrl="https://birds.{domain}" />

<h2 class="align-center mb-2 mt-8 flex items-center gap-2 text-3xl font-semibold">Request Media</h2>
<AppCard
	name="Jellyseerr"
	description="Request movies & shows to be downloaded."
	gradientColours={["#8b74ea", "#b099f7", "#cdaefa"]}
	href="https://den.{domain}"
	notInList
>
	{#snippet icon(className: string)}
		<div class="rounded-md bg-white p-1 {className}">
			<JellyseerrIcon class="h-full w-full" />
		</div>
	{/snippet}
</AppCard>
<div class="align-center mb-2 mt-6 flex items-center">
	<h2 class="align-center flex items-center gap-2 text-xl font-semibold">
		<div class="h-8 w-8 rounded-md bg-white p-1">
			<JellyseerrIcon class="h-full w-full" />
		</div>
		Your Recent Requests
	</h2>
	<a
		href="https://den.{domain}/requests"
		class="align-center text-muted-foreground hover:text-primary ml-auto flex items-center transition-all"
	>
		View all <ChevronRight class="h-4 w-4" />
	</a>
</div>
<JellyseerrRequests {domain} />

<h2 class="align-center mb-2 mt-8 flex items-center gap-2 text-3xl font-semibold">
	Media Downloaders
</h2>
