<script lang="ts">
	import { browser } from "$app/environment";
	import { Carousel, Card } from "$lib/components/ui";
	import { cn } from "$lib/utils";
	import type { BaseItemDto } from "@jellyfin/sdk/lib/generated-client/models";
	import { ImageType } from "@jellyfin/sdk/lib/generated-client/models/image-type";
	import { decodeBlurHash } from "fast-blurhash";

	interface Props {
		item: BaseItemDto;
		domain: string;
	}

	const { item, domain }: Props = $props();
	const {
		Name,
		EpisodeTitle,
		OriginalTitle,
		Id,
		ServerId,
		SeriesName,
		ImageBlurHashes,
		UserData,
		SeriesId,
	} = $derived(item);

	const backdropBlurHash = $derived(ImageBlurHashes?.Backdrop);
	const playedPercentage = $derived(UserData?.PlayedPercentage);

	const getJellyfinImage = (itemId?: string, imageType?: ImageType) => {
		return `/api/jellyfin/getImage?itemId=${encodeURIComponent(itemId ?? "")}&imageType=${imageType ?? "Primary"}`;
	};

	const getItemLink = (itemId?: string, serverId?: string | null) => {
		return `https://birds.${domain}/web/index.html#/details?id=${encodeURIComponent(itemId ?? "")}&serverId=${encodeURIComponent(serverId ?? "")}`;
	};

	let coverLoaded = $state(false);
	let logoLoaded = $state(false);

	let blurHashCanvas: HTMLCanvasElement;
	$effect(() => {
		if (!browser || !backdropBlurHash) return;

		const ctx = blurHashCanvas.getContext("2d");
		if (!ctx) return;
		const firstBlurhashKey = Object.keys(backdropBlurHash)[0];
		const firstBlurhashValue = backdropBlurHash[firstBlurhashKey];
		const pixels = decodeBlurHash(firstBlurhashValue, 32, 32);
		const imageData = ctx.createImageData(32, 32);
		imageData.data.set(pixels);
		ctx.putImageData(imageData, 0, 0);
	});
</script>

<Carousel.Item class="basis-1/4">
	<a href={getItemLink(Id, ServerId)} class="group contents">
		<Card.Root class="aspect-[3/4]">
			<div class="relative h-full w-full overflow-hidden rounded-lg">
				<canvas
					class="absolute inset-0 z-0 h-full w-full rounded-lg"
					width="32"
					height="32"
					bind:this={blurHashCanvas}
				></canvas>
				<img
					src={getJellyfinImage(Id, "Primary")}
					alt={Name}
					class={cn(
						"absolute inset-0 z-10 h-full w-full rounded-lg object-cover transition-all",
						coverLoaded ? "opacity-100" : "opacity-0"
					)}
					onload={() => (coverLoaded = true)}
					loading="lazy"
				/>
				<div class="absolute bottom-0 left-0 z-20 h-2 w-full bg-purple-500/30 backdrop-blur-md">
					<div class="h-full bg-purple-500/60" style="width: {playedPercentage}%"></div>
				</div>
				<div
					class="align-center absolute left-0 top-0 z-[11] flex h-full w-full flex-col items-center justify-center p-4 text-center opacity-0 backdrop-blur-md backdrop-brightness-50 backdrop-saturate-150 transition-all group-hover:opacity-100"
				>
					<img
						src={getJellyfinImage(SeriesId ?? Id, "Logo")}
						alt={Name}
						class="mb-2 h-auto w-full"
						onload={() => (logoLoaded = true)}
					/>
					{#if !logoLoaded}
						<p class="text-lg font-semibold">{SeriesName ?? Name ?? OriginalTitle}</p>
					{/if}
					{#if SeriesName}
						<p class="text-muted-foreground text-sm">
							{#if EpisodeTitle}
								{EpisodeTitle}
							{:else}
								{Name ?? OriginalTitle}
							{/if}
						</p>
					{/if}
				</div>
			</div>
		</Card.Root>
	</a>
</Carousel.Item>
