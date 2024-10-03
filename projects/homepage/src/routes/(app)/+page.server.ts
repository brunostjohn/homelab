import { env } from "$env/dynamic/public";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ parent }) => ({
	publicJellyfinUrl: env.PUBLIC_JELLYFIN_URL,
	rootDomain: (await parent()).domain,
});
