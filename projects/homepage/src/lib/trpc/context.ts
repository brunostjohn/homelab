import { env } from "$env/dynamic/private";
import type { RequestEvent } from "@sveltejs/kit";

export async function createContext(event: RequestEvent) {
	const username = import.meta.env.DEV
		? env.DEVELOPMENT_USER
		: event.request.headers.get("X-authentik-username");

	return {
		event,
		username,
	};
}

export type Context = Awaited<ReturnType<typeof createContext>>;
