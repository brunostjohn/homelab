export interface JellyseerrUser {
	id: number;
	jellyfinUsername: string;
	email: string;
}

export enum JellyseerrMediaStatus {
	UNKNOWN = 1,
	PENDING = 2,
	PROCESSING = 3,
	PARTIALLY_AVAILABLE = 4,
	AVAILABLE = 5,
}

export type JellyseerrMediaType = "movie" | "tv";

export interface JellyseerrDownloadStatus {
	externalId: number;
	mediaType: JellyseerrMediaType;
	size: number;
	sizeLeft: number;
	estimatedCompletionTime: string;
	timeLeft: string;
}

export interface JellyseerrMediaInfo {
	id: number;
	tmdbId: number;
	tvdbId?: number | null;
	imdbId?: number | null;
	status: JellyseerrMediaStatus;
	downloadStatus: JellyseerrDownloadStatus[];
}

export interface JellyseerrRequest {
	id: number;
	createdAt: string;
	updatedAt: string;
	media: JellyseerrMediaInfo;
	type: JellyseerrMediaType;
}

export interface JellyseerMediaMetadata {
	originalTitle: string;
	backdropPath: string;
	posterPath: string;
	releaseDate: string;
}
