import { env } from "$env/dynamic/private";
import { Client } from "minio";

if (!env.S3_ENDPOINT) {
	throw new Error("Missing S3_ENDPOINT in env");
}

if (!env.S3_ACCESS_KEY) {
	throw new Error("Missing S3_PORT in env");
}

if (!env.S3_SECRET_KEY) {
	throw new Error("Missing S3_SECRET_KEY in env");
}

if (!env.S3_BUCKET) {
	throw new Error("Missing S3_BUCKET in env");
}

const portParsed = env.S3_PORT ? parseInt(env.S3_PORT, 10) : undefined;
const port = isNaN(portParsed ?? NaN) ? undefined : portParsed;
export const bucket = env.S3_BUCKET;

export const s3 = new Client({
	endPoint: env.S3_ENDPOINT,
	port,
	useSSL: env.S3_USE_SSL?.toLowerCase() === "true",
	accessKey: env.S3_ACCESS_KEY,
	secretKey: env.S3_SECRET_KEY,
});
