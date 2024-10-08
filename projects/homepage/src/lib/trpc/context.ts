import { env } from "$env/dynamic/private";
import { Configuration, CoreApi } from "$lib/generatedApiClients/authentik";
import type { RequestEvent } from "@sveltejs/kit";

const authentikApiConfiguration = new Configuration({
	basePath: env.AUTHENTIK_URL + "/api/v3",
	headers: {
		Authorization: `Bearer ${env.AUTHENTIK_API_KEY}`,
	},
});

const authentikCoreApi = new CoreApi(authentikApiConfiguration);

export async function createContext(event: RequestEvent) {
	const username = import.meta.env.DEV
		? env.DEVELOPMENT_USER
		: event.request.headers.get("X-authentik-username")!;

	const {
		results: [user],
	} = await authentikCoreApi.coreUsersList({
		username,
	});

	if (!user) {
		throw new Error("User not found");
	}

	return {
		event,
		username,
		user,
	};
}

export type Context = Awaited<ReturnType<typeof createContext>>;
