import { env } from "$env/dynamic/private";
import { env as envPublic } from "$env/dynamic/public";
import {
	getAllApiAdminUsersGet,
	getAllApiRecipesGet,
	getOneApiAdminGroupsItemIdGet,
	getOneApiAdminUsersItemIdGet,
} from "$lib/generatedApiClients/mealie";
import t from "$lib/trpc/t";
import { createClient } from "@hey-api/client-fetch";

const client = createClient({
	baseUrl: env.MEALIE_URL,
	headers: {
		Authorization: `Bearer ${env.MEALIE_API_KEY}`,
	},
});

interface Recipe {
	id: string;
	name: string;
	slug: string;
	image?: string;
	groupSlug: string;
	totalTime?: string | null;
	description?: string | null;
}

export const mealieRouter = t.router({
	newestRecipes: t.procedure.query(
		async ({
			ctx: {
				user: { email },
			},
		}) => {
			const { data: userData, error: userError } = await getAllApiAdminUsersGet({ client });
			if (userError || !userData) {
				throw new Error(userError?.detail?.join(" ") ?? "Failed to fetch user data");
			}
			const { items: users } = userData;
			const user = users.find((u) => u.email === email);
			if (!user) {
				throw new Error("User not found");
			}

			const { data, error } = await getAllApiRecipesGet({
				client,
				query: { orderBy: "created_at", perPage: 50 },
			});
			if (error) {
				throw new Error(error.detail?.join(" "));
			}
			if (!data) {
				return [];
			}

			const { items: recipes } = data;

			return recipes
				.filter(({ groupId, description }) => groupId === user.groupId && description)
				.map(({ id, name, slug, image, totalTime, description }) => ({
					id: id!,
					name: name!,
					slug: slug!,
					image: image
						? `https://mealie.${envPublic.PUBLIC_DOMAIN}/api/media/recipes/${id}/images/min-original.webp`
						: undefined,
					totalTime,
					description,
					groupSlug: user.groupSlug!,
				}))
				.slice(0, 15);
		}
	),
});
