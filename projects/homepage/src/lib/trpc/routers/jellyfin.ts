import { Jellyfin } from "@jellyfin/sdk";
import { getUserLibraryApi } from "@jellyfin/sdk/lib/utils/api/user-library-api";
import { getUserApi } from "@jellyfin/sdk/lib/utils/api/user-api";
import { getImageApi } from "@jellyfin/sdk/lib/utils/api/image-api";
import { z } from "zod";
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
	latestMedia: t.procedure.query(async () => {
		let id: string | undefined = "";

		try {
			const {
				data: { Id: newId },
			} = await getUserApi(api).getCurrentUser();
			id = newId;
		} catch (e) {
			console.warn("no one owns this session");
		}

		if (!id || id === "") {
			const { data: users } = await getUserApi(api).getUsers();
			id = users.find(({ Id }) => Id)?.Id;
		}

		const { data: userLibrary } = await getUserLibraryApi(api).getLatestMedia({
			userId: id,
			enableImages: true,
			includeItemTypes: ["Movie", "Series"],
		});
		return userLibrary;
	}),
});
