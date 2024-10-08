import { Jellyfin } from "@jellyfin/sdk";
import { getUserLibraryApi } from "@jellyfin/sdk/lib/utils/api/user-library-api";
import { getUserApi } from "@jellyfin/sdk/lib/utils/api/user-api";
import { getItemsApi } from "@jellyfin/sdk/lib/utils/api/items-api";
import { hostname } from "os";
import t from "../t";
import { env } from "$env/dynamic/private";

const jellyfin = new Jellyfin({
	clientInfo: {
		name: "Homepage",
		version: "1.0.0",
	},
	deviceInfo: {
		name: "Homepage",
		id: hostname(),
	},
});

const api = jellyfin.createApi(env.JELLYFIN_URL ?? "", env.JELLYFIN_TOKEN);

export const jellyfinRouter = t.router({
	latestMedia: t.procedure.query(async ({ ctx: { username } }) => {
		let id: string | undefined = "";

		try {
			const {
				data: { Id: newId },
			} = await getUserApi(api).getCurrentUser();
			id = newId;
		} catch (e) {}

		if (!id || id === "") {
			const { data: users } = await getUserApi(api).getUsers();

			if (username) {
				id = users.find(({ Name }) => Name === username)?.Id;
			}

			if (!id) id = users.find(({ Id }) => Id)?.Id;
		}

		const { data: userLibrary } = await getUserLibraryApi(api).getLatestMedia({
			userId: id,
			enableImages: true,
			includeItemTypes: ["Movie", "Series"],
		});

		return userLibrary;
	}),

	resume: t.procedure.query(async ({ ctx: { username } }) => {
		const { data: users } = await getUserApi(api).getUsers();

		if (!username) return [];
		const id = users.find(({ Name }) => Name === username)?.Id;
		if (!id) return [];

		const {
			data: { Items },
		} = await getItemsApi(api).getResumeItems({
			userId: id,
			enableImages: true,
			enableUserData: true,
		});

		return Items;
	}),
});
