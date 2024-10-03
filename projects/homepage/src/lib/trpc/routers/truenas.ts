import { env } from "$env/dynamic/private";
import t from "$lib/trpc/t";

interface Pool {
	name: string;
	size: number;
	allocated: number;
	status: string;
}

const getPools = async (apiUrl: string, apiToken: string, fetchFn: typeof fetch) => {
	const authenticatedFetch = (url: string, init?: RequestInit) =>
		fetchFn(url, {
			...init,
			headers: {
				...init?.headers,
				Authorization: `Bearer ${apiToken}`,
			},
		});

	const response = await authenticatedFetch(`${apiUrl}/api/v2.0/pool`);
	const data = await response.json();
	return data as Pool[];
};

export const truenasRouter = t.router({
	poolStats: t.procedure.query(
		async ({
			ctx: {
				event: { fetch },
			},
		}) => {
			const jabberwockPools = await getPools(
				env.TRUENAS_JABBERWOCK,
				env.TRUENAS_JABBERWOCK_API_KEY,
				fetch
			);
			const floofPools = await getPools(env.TRUENAS_FLOOF, env.TRUENAS_FLOOF_API_KEY, fetch);
			const lookingglassPools = await getPools(
				env.TRUENAS_LOOKINGGLASS,
				env.TRUENAS_LOOKINGGLASS_API_KEY,
				fetch
			);
			const pools = [...jabberwockPools, ...floofPools, ...lookingglassPools];

			return pools.filter(({ status }) => status === "ONLINE");
		}
	),
});
