<script lang="ts">
	import { Carousel, Card } from "$lib/components/ui";
	import type { BaseItemDto } from "@jellyfin/sdk/lib/generated-client/models/base-item-dto";
	import type { ImageType } from "@jellyfin/sdk/lib/generated-client/models/image-type";

	interface Props {
		item: BaseItemDto;
		serverPublicUrl: string;
	}

	const { item, serverPublicUrl }: Props = $props();
	const { Name, OriginalTitle, Id, ServerId } = $derived(item);

	let failedImageLoad = $state(false);
	const handleImageLoadError = () => {
		failedImageLoad = true;
	};

	const getJellyfinImage = (itemId?: string, imageType?: ImageType) => {
		return `/api/jellyfin/getImage?itemId=${encodeURIComponent(itemId ?? "")}&imageType=${imageType ?? "Primary"}`;
	};

	const getItemLink = (itemId?: string, serverId?: string | null) => {
		return `${serverPublicUrl}/web/index.html#/details?id=${encodeURIComponent(itemId ?? "")}&serverId=${encodeURIComponent(serverId ?? "")}`;
	};
</script>

<Carousel.Item class="">
	<div class="p-1">
		<a href={getItemLink(Id, ServerId)} class="contents" target="_blank">
			<Card.Root
				class="hover:border-primary/30 transition-all"
				style="background: linear-gradient(rgba(0,0,0,0.0) 0%, rgba(0,0,0,0.6) 30%, rgba(0,0,0,0.9) 60%), url('{getJellyfinImage(
					item.Id,
					'Backdrop'
				)}'); background-repeat: no-repeat; background-position: center center; background-size: cover;"
			>
				<Card.Content class="flex h-96 items-end justify-start p-8">
					<div>
						{#if !failedImageLoad}
							<img
								src={getJellyfinImage(item.Id, "Logo")}
								alt={Name ?? OriginalTitle}
								onerror={handleImageLoadError}
								class=" max-w-80"
							/>
						{:else}
							<p>{Name ?? OriginalTitle}</p>
						{/if}
					</div>
				</Card.Content>
			</Card.Root>
		</a>
	</div>
</Carousel.Item>
