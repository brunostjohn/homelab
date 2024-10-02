import { kubeRouter } from "./routers";
import t from "./t";

export const router = t.router({
	kube: kubeRouter,
});

export const createCaller = t.createCallerFactory(router);

export type Router = typeof router;
