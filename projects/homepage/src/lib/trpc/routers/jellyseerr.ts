import { env } from "$env/dynamic/private";
import t from "$lib/trpc/t";
import type { JellyseerMediaMetadata, JellyseerrRequest, JellyseerrUser } from "./jellyseerrTypes";

const jellyseerrBaseUrl = env.JELLYSEERR_BASE_URL;
const jellyseerrApiKey = env.JELLYSEERR_API_KEY;

export const jellyseerrRouter = t.router({
	recentRequests: t.procedure.query(
		async ({
			ctx: {
				username,
				event: { fetch },
			},
		}) => {
			const authenticatedFetch = async (input: string, init?: RequestInit) =>
				fetch(jellyseerrBaseUrl + "/api/v1" + input, {
					...init,
					headers: {
						...init?.headers,
						"X-Api-Key": jellyseerrApiKey,
					},
				});

			const users = await authenticatedFetch("/user");
			const { results: usersJson }: { results: JellyseerrUser[] } = await users.json();

			const userId = usersJson.find(
				(user) => user.jellyfinUsername === username || user.email === username
			)?.id;
			if (!userId) {
				return [];
			}

			const requests = await authenticatedFetch(`/user/${userId}/requests?take=6`);
			const { results: requestsJson }: { results: JellyseerrRequest[] } = await requests.json();
			const resultsWithPosters = await Promise.all(
				requestsJson.map(async (request) => {
					const data: JellyseerMediaMetadata = await authenticatedFetch(
						`/${request.type}/${request.type === "movie" ? request.media.tmdbId : request.media.tvdbId}/`
					).then((res) => res.json());

					return {
						...request,
						media: {
							...request.media,
							mediaMeta: data,
							poster: `https://image.tmdb.org/t/p/w600_and_h900_bestv2${data.posterPath}`,
							backdrop: `https://image.tmdb.org/t/p/w1920_and_h800_multi_faces${data.backdropPath}`,
						},
					};
				})
			);

			return resultsWithPosters;
		}
	),
});
