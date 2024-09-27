import { env } from "$env/dynamic/public";
import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = ({ params: { status } }) => ({
	staticUrl: env.PUBLIC_STATIC_URL,
	homepageUrl: env.PUBLIC_HOMEPAGE_URL,
	errorCode: status,
});
