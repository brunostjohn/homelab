import t from "$lib/trpc/t";
import { CoreV1Api, KubeConfig, Metrics } from "@kubernetes/client-node";

const kc = new KubeConfig();

if (import.meta.env.DEV) {
	kc.loadFromDefault();
} else {
	kc.loadFromCluster();
}

export const kubeRouter = t.router({
	metrics: t.procedure.query(async () => {
		const coreApi = kc.makeApiClient(CoreV1Api);
		const metricsApi = new Metrics(kc);
		const { body: nodes } = await coreApi.listNode();

		let cpuTotal = 0;
		let cpuUsage = 0;
		let memTotal = 0;
		let memUsage = 0;

		const nodeMap: {
			[key: string]: {
				name: string;
				ready: boolean;
				cpu: { total: number };
				memory: { total: number };
			};
		} = {};
		nodes.items.forEach((node) => {
			const cpu = Number.parseInt(node.status?.capacity?.cpu ?? "0", 10);
			const mem = parseMemory(node.status?.capacity?.memory ?? "0");
			const ready =
				(node.status?.conditions?.filter(
					(condition) => condition.type === "Ready" && condition.status === "True"
				).length ?? 0) > 0;
			nodeMap[node.metadata.name] = {
				name: node.metadata?.name,
				ready,
				cpu: {
					total: cpu,
				},
				memory: {
					total: mem,
				},
			};
			cpuTotal += cpu;
			memTotal += mem;
		});

		const nodeMetrics = await metricsApi.getNodeMetrics();
		nodeMetrics.items.forEach((nodeMetric) => {
			const cpu = parseCpu(nodeMetric.usage.cpu);
			const mem = parseMemory(nodeMetric.usage.memory);
			cpuUsage += cpu;
			memUsage += mem;
			nodeMap[nodeMetric.metadata.name].cpu.load = cpu;
			nodeMap[nodeMetric.metadata.name].cpu.percent =
				(cpu / nodeMap[nodeMetric.metadata.name].cpu.total) * 100;
			nodeMap[nodeMetric.metadata.name].memory.used = mem;
			nodeMap[nodeMetric.metadata.name].memory.free =
				nodeMap[nodeMetric.metadata.name].memory.total - mem;
			nodeMap[nodeMetric.metadata.name].memory.percent =
				(mem / nodeMap[nodeMetric.metadata.name].memory.total) * 100;
		});

		const cluster = {
			cpu: {
				load: cpuUsage,
				total: cpuTotal,
				percent: (cpuUsage / cpuTotal) * 100,
			},
			memory: {
				used: memUsage,
				total: memTotal,
				free: memTotal - memUsage,
				percent: (memUsage / memTotal) * 100,
			},
			nodes: Object.entries(nodeMap).map(([name, node]) => ({ name, ...node })),
		};

		return cluster;
	}),
});

export function parseCpu(cpuStr: string) {
	const unitLength = 1;
	const base = Number.parseInt(cpuStr, 10);
	const units = cpuStr.substring(cpuStr.length - unitLength);
	if (Number.isNaN(Number(units))) {
		switch (units) {
			case "n":
				return base / 1000000000;
			case "u":
				return base / 1000000;
			case "m":
				return base / 1000;
			default:
				return base;
		}
	} else {
		return Number.parseInt(cpuStr, 10);
	}
}

export function parseMemory(memStr: string) {
	const unitLength = memStr.substring(memStr.length - 1) === "i" ? 2 : 1;
	const base = Number.parseInt(memStr, 10);
	const units = memStr.substring(memStr.length - unitLength);
	if (Number.isNaN(Number(units))) {
		switch (units) {
			case "Ki":
				return base * 1000;
			case "K":
				return base * 1024;
			case "Mi":
				return base * 1000000;
			case "M":
				return base * 1024 * 1024;
			case "Gi":
				return base * 1000000000;
			case "G":
				return base * 1024 * 1024 * 1024;
			default:
				return base;
		}
	} else {
		return Number.parseInt(memStr, 10);
	}
}
