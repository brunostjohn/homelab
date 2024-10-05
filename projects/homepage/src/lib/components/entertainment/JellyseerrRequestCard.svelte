<script lang="ts">
	import { Badge, Card } from "$lib/components/ui";
	import moment from "moment";
	import {
		JellyseerrMediaStatus,
		type JellyseerMediaMetadata,
		type JellyseerrRequest,
	} from "$lib/trpc/routers/jellyseerrTypes";
	import { filesize } from "filesize";
	import { ChevronRight } from "lucide-svelte";

	interface Props {
		domain: string;
		request: JellyseerrRequest & {
			media: JellyseerrRequest["media"] & {
				backdrop: string | null;
				poster: string | null;
				mediaMeta: JellyseerMediaMetadata;
			};
		};
	}

	const { request, domain }: Props = $props();
	const {
		type,
		media: {
			id,
			tmdbId,
			tvdbId,
			backdrop,
			poster,
			status,
			downloadStatus: downloads,
			mediaMeta: { originalTitle, releaseDate },
		},
	} = $derived(request);
	const yearReleased = $derived(new Date(releaseDate).getFullYear());

	const badgeText = $derived.by(() => {
		switch (status) {
			case JellyseerrMediaStatus.PENDING:
				return "Pending";
			case JellyseerrMediaStatus.PROCESSING:
				return "Processing";
			case JellyseerrMediaStatus.UNKNOWN:
				return "Unknown";
			case JellyseerrMediaStatus.PARTIALLY_AVAILABLE:
				return "Partially Available";
			case JellyseerrMediaStatus.AVAILABLE:
				return "Available";
			default:
				return "Unknown";
		}
	});

	const badgeColour = $derived.by(() => {
		switch (status) {
			case JellyseerrMediaStatus.PENDING:
				return "bg-yellow-300";
			case JellyseerrMediaStatus.PROCESSING:
				return "bg-blue-300";
			case JellyseerrMediaStatus.UNKNOWN:
				return "bg-gray-300";
			case JellyseerrMediaStatus.PARTIALLY_AVAILABLE:
				return "bg-yellow-300";
			case JellyseerrMediaStatus.AVAILABLE:
				return "bg-green-300";
			default:
				return "bg-gray-300";
		}
	});

	const eta = $derived(
		moment(downloads[0].estimatedCompletionTime).fromNow() === "Invalid date"
			? null
			: moment(downloads[0].estimatedCompletionTime).fromNow()
	);
</script>

<li>
	<a
		class="group contents"
		href={`https://den.${domain}/${type}/${type === "movie" ? tmdbId : tvdbId}`}
		target="_blank"
	>
		<Card.Root class="group-hover:border-muted-foreground relative overflow-hidden transition-all">
			<img
				src={backdrop}
				aria-hidden="true"
				alt="{originalTitle} Backdrop"
				loading="lazy"
				class="absolute inset-0 h-full w-full object-cover blur-2xl brightness-50 saturate-150"
			/>
			<Card.Content class="flex gap-4 p-4">
				<div class="relative z-0 aspect-[2/3] h-full max-h-48 min-h-48 overflow-hidden rounded-md">
					<img src={poster} alt="{originalTitle} Poster" class="absolute h-full" loading="lazy" />
				</div>
				<div class="z-10 flex w-full flex-col">
					<p class="text-sm">{yearReleased}</p>
					<p class="text-lg font-semibold text-white">{originalTitle}</p>
					<Badge class="mt-1 w-max {badgeColour}">{badgeText}</Badge>
					{#if downloads.length > 1 && status !== JellyseerrMediaStatus.AVAILABLE}
						<p class="text-muted-foreground mt-auto text-sm">
							{downloads.filter((download) => download.sizeLeft !== 0).length} downloads in progress
						</p>
					{:else if downloads.length === 1 && status !== JellyseerrMediaStatus.AVAILABLE && downloads[0].sizeLeft !== 0}
						<p class="text-primary/50 mt-auto text-xs">
							{filesize(downloads[0].sizeLeft)} left
						</p>
						{#if eta}
							<p class="text-primary/50 mb-1 text-xs">
								Available {eta}
							</p>
						{/if}
						<div class="bg-muted/30 h-3 w-full overflow-hidden rounded-full">
							<div
								class="bg-primary/50 h-full animate-pulse rounded-full"
								style={`width: ${downloads[0].sizeLeft / downloads[0].size}%`}
							></div>
						</div>
					{/if}
				</div>
				<ChevronRight class="my-auto ml-auto h-6 min-h-6 w-6 min-w-6 text-white" />
			</Card.Content>
		</Card.Root>
	</a>
</li>
