import type { Context } from "$lib/trpc/context";
import { initTRPC } from "@trpc/server";

const t = initTRPC.context<Context>().create();
export default t;
