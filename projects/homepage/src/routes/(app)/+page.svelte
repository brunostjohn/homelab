<script lang="ts">
	import { JellyfinLatestCarousel } from "$lib/components/media";
	import { Button } from "$lib/components/ui";
	import type { PageServerData } from "./$types";
	import { AppCard } from "$lib/components/app";
	import {
		AudiobookshelfIcon,
		ImmichIcon,
		JellyfinIcon,
		NextcloudIcon,
		RommIcon,
		VaultwardenIcon,
	} from "$lib/components/icons";
	import { ChevronRight, Cloud } from "lucide-svelte";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { publicJellyfinUrl, rootDomain } = $derived(data);
</script>

<JellyfinLatestCarousel serverPublicUrl={publicJellyfinUrl} />

<section class="my-4">
	<h2 class="align-center flex items-center gap-2 text-2xl font-medium">Entertainment Apps</h2>

	<ul class="mt-2 grid grid-cols-2 gap-2" style="grid-auto-rows: 1fr;">
		<AppCard
			name="Jellyfin"
			description="Watch movies & shows, listen to music."
			gradientColours={["#020b23", "#1f52aa", "#226e80"]}
			href={publicJellyfinUrl}
		>
			{#snippet icon(className: string)}
				<JellyfinIcon class={className} />
			{/snippet}
		</AppCard>

		<AppCard
			name="Romm"
			description="Collect & download game console roms."
			href="https://romm.{rootDomain}"
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
			href="https://audiobookshelf.{rootDomain}"
			gradientColours={["#8b622b", "#a07333", "#c89c53"]}
		>
			{#snippet icon(className: string)}
				<div class="aspect-square bg-white p-1 {className}">
					<AudiobookshelfIcon />
				</div>
			{/snippet}
		</AppCard>

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
		<AppCard
			name="Immich"
			description="Watch movies & shows, listen to music."
			gradientColours={["#020b23", "#1f52aa", "#226e80"]}
			href={publicJellyfinUrl}
		>
			{#snippet icon(className: string)}
				<div class="aspect-square bg-white p-1 {className}">
					<ImmichIcon />
				</div>
			{/snippet}
		</AppCard>

		<AppCard
			name="Vaultwarden"
			description="Collect & download game console roms."
			href="https://romm.{rootDomain}"
			gradientColours={["#4200d0", "#7200df", "#ce00fb"]}
		>
			{#snippet icon(className: string)}
				<div
					class="align-center flex aspect-square items-center justify-center bg-white p-1 {className}"
				>
					<VaultwardenIcon />
				</div>
			{/snippet}
		</AppCard>

		<AppCard
			name="Nextcloud"
			description="Listen to audiobooks & podcasts."
			href="https://audiobookshelf.{rootDomain}"
			gradientColours={["#8b622b", "#a07333", "#c89c53"]}
		>
			{#snippet icon(className: string)}
				<div
					class="align-center jusitfy-center flex aspect-square items-center bg-white p-1 {className}"
				>
					<NextcloudIcon />
				</div>
			{/snippet}
		</AppCard>
	</ul>
</section>
