import t from "$lib/trpc/t";
import { env } from "$env/dynamic/private";
import { Controller } from "unifi-client";

const unifiUrl = env.UNIFI_URL;
const unifiUsername = env.UNIFI_USERNAME;
const unifiPassword = env.UNIFI_PASSWORD;

const controller = new Controller({
	url: unifiUrl,
	username: unifiUsername,
	password: unifiPassword,
	strictSSL: false,
});

process.on("exit", () => controller.logout());

export const unifiRouter = t.router({
	siteStats: t.procedure.query(async () => {
		// if (!controller.logged) await controller.login();
		// const [site] = await controller.getSites();
		// const stats = await controller.buildUrl({});
		// console.log(stats);
	}),
});
