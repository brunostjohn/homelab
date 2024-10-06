import type { PageServerLoad } from "./$types";

export const load: PageServerLoad = async ({ parent }) => ({
	domain: (await parent()).domain,
});
