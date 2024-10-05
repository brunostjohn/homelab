import {
	downloadClientsRouter,
	jellyfinRouter,
	jellyseerrRouter,
	kubeRouter,
	truenasRouter,
	unifiRouter,
} from "./routers";
import t from "./t";

export const router = t.router({
	kube: kubeRouter,
	jellyfin: jellyfinRouter,
	unifi: unifiRouter,
	jellyseerr: jellyseerrRouter,
	trueNas: truenasRouter,
	downloadClients: downloadClientsRouter,
});

export const createCaller = t.createCallerFactory(router);

export type Router = typeof router;
