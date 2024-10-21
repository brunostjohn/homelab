<script lang="ts">
	import { KubeStats, NetworkStats, SidebarLink, StorageStats } from "$lib/components/sidebar";
	import { BookOpenText, Cable } from "lucide-svelte";
	import type { Snippet } from "svelte";
	import GlobalCommand from "../GlobalCommand.svelte";
	import UserMenu from "../UserMenu.svelte";
	import { Separator } from "$lib/components/ui";

	interface Props {
		children: Snippet;
		domain: string;
	}

	const { children, domain }: Props = $props();
</script>

<div class="mx-auto flex h-full w-full max-w-screen-xl">
	<div class="my-6 flex">
		<aside class="flex w-full min-w-72 flex-col overflow-y-auto py-4 pl-4 pr-4 xl:pl-0">
			<div class="align-center mb-2 flex items-center">
				<enhanced:img src="$lib/assets/icon.png" class="w-16 pr-2" alt="Server Logo" />
				<h1 class="text-2xl font-semibold">Zefir&apos;s Cloud</h1>
			</div>
			<ul class="mb-4 flex flex-col gap-1">
				<SidebarLink href="https://status.{domain}">
					{#snippet icon(className: string)}
						<Cable class={className} />
					{/snippet}
					Uptime status
				</SidebarLink>
				<SidebarLink href="https://docs.{domain}">
					{#snippet icon(className: string)}
						<BookOpenText class={className} />
					{/snippet}
					Documentation
				</SidebarLink>
			</ul>

			<KubeStats />
			<NetworkStats />
			<StorageStats />

			<GlobalCommand />
			<UserMenu {domain} />
		</aside>
		<Separator orientation="vertical" />
	</div>

	<main class="h-full w-full overflow-y-auto overflow-x-hidden px-20 py-8">
		{@render children()}
	</main>
</div>
