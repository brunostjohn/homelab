import { env } from "$env/dynamic/private";
import {
	getChatByIdChatsIdGet,
	getUserChatListByUserIdChatsListUserUserIdGet,
	getUsersUsersGet,
} from "$lib/generatedApiClients/open-webui";
import t from "$lib/trpc/t";
import { createClient } from "@hey-api/client-fetch";

const client = createClient({
	baseUrl: env.OPENWEBUI_URL + "/api/v1",
	headers: {
		Authorization: `Bearer ${env.OPENWEBUI_API_KEY}`,
	},
});

export const openwebuiRouter = t.router({
	recentConversations: t.procedure.query(
		async ({
			ctx: {
				user: { email },
			},
		}) => {
			const { data, error } = await getUsersUsersGet({ client });
			if (error) {
				throw new Error(error.detail?.join(" "));
			}

			if (!data) {
				throw new Error("No data returned");
			}

			const user = data.find((user) => user.email === email);
			if (!user) {
				return [];
			}
			const { id } = user;

			const { data: chats, error: chatError } = await getUserChatListByUserIdChatsListUserUserIdGet(
				{ client, path: { user_id: id } }
			);
			if (chatError) {
				throw new Error(chatError.detail?.join(" "));
			}

			if (!chats) {
				return [];
			}

			return Promise.all(
				chats.map(async ({ id, ...rest }) => {
					const { data: chatData, error: chatError } = await getChatByIdChatsIdGet({
						client,
						path: { id },
					});
					if (chatError) {
						return { id, ...rest };
					}

					return { id, ...rest, ...chatData };
				})
			);
		}
	),
});
