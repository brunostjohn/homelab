import { jellyfinRouter, kubeRouter } from "./routers";
import t from "./t";

export const router = t.router({
	kube: kubeRouter,
	jellyfin: jellyfinRouter,
});

export const createCaller = t.createCallerFactory(router);

export type Router = typeof router;
