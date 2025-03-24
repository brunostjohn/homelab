import { z } from "zod";
import type { RequestHandler } from "./$types";
import { error } from "@sveltejs/kit";
import { env } from "$env/dynamic/private";
import { hostname } from "os";
import type { ImageType } from "@jellyfin/sdk/lib/generated-client/models";
import { getImageApi } from "@jellyfin/sdk/lib/utils/api";
import { Jellyfin } from "@jellyfin/sdk";

const schema = z.object({
	itemId: z.string(),
	imageType: z.enum(["Primary", "Backdrop", "Thumb", "Banner", "Logo", "Box"]),
});

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

export const GET: RequestHandler = async ({ url: { searchParams }, setHeaders, fetch }) => {
	const itemId = searchParams.get("itemId");
	const imageType = searchParams.get("imageType");
	if (!itemId || !imageType) {
		return error(400, "Missing required parameters");
	}
	const { itemId: id, imageType: type } = schema.parse({ itemId, imageType });
	const imageApi = await getImageApi(api);
	const url = imageApi.getItemImageUrl({ Id: id }, type as ImageType);

	if (!url) {
		return error(404, "Image not found");
	}

	const res = await fetch(url);
	const buf = await res.arrayBuffer();
	setHeaders({
		"Content-Type": res.headers.get("Content-Type") ?? "image/jpeg",
	});

	return new Response(buf);
};
