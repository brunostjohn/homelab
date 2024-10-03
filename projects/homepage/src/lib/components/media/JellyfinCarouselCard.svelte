<script lang="ts">
	import { browser } from "$app/environment";
	import { decodeBlurHash } from "fast-blurhash";
	import { Carousel, Card } from "$lib/components/ui";
	import { cn } from "$lib/utils";
	import type { BaseItemDto } from "@jellyfin/sdk/lib/generated-client/models/base-item-dto";
	import type { ImageType } from "@jellyfin/sdk/lib/generated-client/models/image-type";
	import { ArrowRightIcon, Calendar, Clapperboard, Drama } from "lucide-svelte";

	interface Props {
		item: BaseItemDto;
		serverPublicUrl: string;
	}

	const { item, serverPublicUrl }: Props = $props();
	const { Name, OriginalTitle, Id, ServerId, Type, CriticRating, ProductionYear, ImageBlurHashes } =
		$derived(item);
	const backdropBlurHash = $derived(ImageBlurHashes?.Backdrop);

	let failedImageLoad = $state(false);
	const handleImageLoadError = () => {
		failedImageLoad = true;
	};
	let imageLoaded = $state(false);

	const getJellyfinImage = (itemId?: string, imageType?: ImageType) => {
		return `/api/jellyfin/getImage?itemId=${encodeURIComponent(itemId ?? "")}&imageType=${imageType ?? "Primary"}`;
	};

	const getItemLink = (itemId?: string, serverId?: string | null) => {
		return `${serverPublicUrl}/web/index.html#/details?id=${encodeURIComponent(itemId ?? "")}&serverId=${encodeURIComponent(serverId ?? "")}`;
	};

	let isBackdropLoaded = $state(false);
	let blurhashCanvas: HTMLCanvasElement;

	$effect(() => {
		if (!browser || !backdropBlurHash) return;

		const ctx = blurhashCanvas.getContext("2d");
		if (!ctx) return;
		const firstBlurhashKey = Object.keys(backdropBlurHash)[0];
		const firstBlurhashValue = backdropBlurHash[firstBlurhashKey];
		const pixels = decodeBlurHash(firstBlurhashValue, 32, 32);
		const imageData = ctx.createImageData(32, 32);
		imageData.data.set(pixels);
		ctx.putImageData(imageData, 0, 0);
	});
</script>

<Carousel.Item class="">
	<div class="p-1">
		<a href={getItemLink(Id, ServerId)} class="contents" target="_blank">
			<Card.Root class="hover:border-primary/30 relative transition-all">
				<canvas
					bind:this={blurhashCanvas}
					class="absolute left-0 top-0 h-full w-full rounded-lg"
					width="32"
					height="32"
				></canvas>
				<img
					src={getJellyfinImage(item.Id, "Backdrop")}
					alt={Name ?? OriginalTitle}
					class={cn(
						"absolute left-0 top-0 z-0 h-full w-full rounded-lg object-cover transition-all",
						isBackdropLoaded ? "opacity-100" : "opacity-0"
					)}
					loading="lazy"
					onload={() => (isBackdropLoaded = true)}
				/>
				<div
					aria-hidden="true"
					style="mask-image: linear-gradient(rgba(0, 0, 0, 0) 0%, rgba(0,0,0,0.7) 40%, rgba(0, 0, 0, 1) 70%);"
					class="absolute left-0 top-0 h-full w-full rounded-lg backdrop-blur-md backdrop-brightness-[25%]"
				></div>
				<Card.Content class="relative flex h-96 min-h-96 items-end justify-start p-6">
					<div class="">
						{#if !failedImageLoad}
							<img
								src={getJellyfinImage(item.Id, "Logo")}
								alt={Name ?? OriginalTitle}
								onerror={handleImageLoadError}
								onload={() => (imageLoaded = true)}
								class="mb-4 max-w-80"
								loading="lazy"
							/>
						{/if}

						{#if failedImageLoad || !imageLoaded}
							<p class="mb-4 max-w-[36rem] text-4xl">{Name ?? OriginalTitle}</p>
						{/if}
						<div class="align-center flex items-center gap-4">
							<p class="align-center text-muted-foreground flex items-center text-sm">
								<Calendar class="mr-1 inline-block h-4 w-4" />
								{ProductionYear}
							</p>
							{#if Type === "Movie"}
								<p class="align-center text-muted-foreground flex items-center text-sm">
									<Clapperboard class="mr-1 inline-block h-4 w-4" />
									Movie
								</p>
							{:else if Type === "Series"}
								<p class="align-center text-muted-foreground flex items-center text-sm">
									<Drama class="mr-1 inline-block h-4 w-4" />
									Series
								</p>
							{/if}
							{#if CriticRating}
								<p class="align-center text-muted-foreground flex items-center text-sm">
									<span class="mr-1 inline-block h-4 w-4">🍅</span>
									{CriticRating}
								</p>
							{/if}
						</div>
					</div>
					<p
						class="align-center text-muted-foreground ml-auto flex items-center justify-center gap-1 text-sm font-semibold uppercase"
					>
						Stream now
						<ArrowRightIcon class="h-4 w-4" />
					</p>
				</Card.Content>
			</Card.Root>
		</a>
	</div>
</Carousel.Item>
