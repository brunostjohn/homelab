import { svelteQueryWrapper } from "trpc-svelte-query-adapter";
import type { QueryClient } from "@tanstack/svelte-query";
import type { Router } from "./router";
import { createTRPCClient, type TRPCClientInit } from "trpc-sveltekit";
import { browser } from "$app/environment";
import { httpLink } from "@trpc/client/links/httpLink";

let browserClient: ReturnType<typeof svelteQueryWrapper<Router>>;

export function trpc(init?: TRPCClientInit, queryClient?: QueryClient) {
	if (!browser) return;
	if (browser && browserClient) return browserClient;
	const client = svelteQueryWrapper<Router>({
		client: createTRPCClient<Router>({ links: [httpLink({ url: "/trpc" })] }),
		queryClient,
	});
	if (browser) browserClient = client;
	return client;
}
