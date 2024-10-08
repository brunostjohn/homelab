import {
	downloadClientsRouter,
	jellyfinRouter,
	jellyseerrRouter,
	kubeRouter,
	mediaFetcherRouter,
	openwebuiRouter,
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
	mediaFetchers: mediaFetcherRouter,
	openwebui: openwebuiRouter,
});

export const createCaller = t.createCallerFactory(router);

export type Router = typeof router;
