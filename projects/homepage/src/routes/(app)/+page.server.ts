import { env } from "$env/dynamic/public";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = () => ({ publicJellyfinUrl: env.PUBLIC_JELLYFIN_URL });
