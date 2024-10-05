import type { LayoutServerLoad } from "./$types";
import { env } from "$env/dynamic/public";
import { env as envPrivate } from "$env/dynamic/private";

const getDomain = () => {
	const initialValue = env.PUBLIC_DOMAIN ?? "localhost:5173";
	if (initialValue.endsWith("/")) return initialValue.slice(0, -1);
	return initialValue;
};

export const load: LayoutServerLoad = ({ request: { headers } }) => ({
	domain: getDomain(),
	username: import.meta.env.DEV ? envPrivate.DEVELOPMENT_USER : headers.get("X-authentik-username"),
});
