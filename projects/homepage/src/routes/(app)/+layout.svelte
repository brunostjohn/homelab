<script lang="ts">
	import { Separator } from "$lib/components";
	import { KubeStats, NetworkStats, SidebarLink, StorageStats } from "$lib/components/sidebar";
	import type { LayoutServerData } from "./$types";
	import { LogOut, BookOpenText, Fingerprint, KeyRound, Cable } from "lucide-svelte";
	import type { Snippet } from "svelte";

	interface Props {
		children: Snippet;
		data: LayoutServerData;
	}

	const { data, children }: Props = $props();
	const { domain } = $derived(data);
</script>

<svelte:head>
	<title>Zefir&apos;s Cloud</title>
</svelte:head>

<div class="mx-auto flex h-full w-full max-w-screen-xl overflow-hidden">
	<div class="my-6 flex">
		<aside class="flex w-72 flex-col overflow-y-auto py-4 pr-8">
			<div class="align-center mb-4 flex items-center">
				<enhanced:img src="$lib/assets/icon.png" class="w-16 pr-2" alt="Server Logo" />
				<h1 class="text-2xl font-semibold">Zefir&apos;s Cloud</h1>
			</div>

			<KubeStats />

			<NetworkStats />

			<StorageStats />

			<ul class="mt-auto flex flex-col gap-1 pt-4">
				<SidebarLink href="https://{domain}/signout">
					{#snippet icon(className: string)}
						<LogOut class={className} />
					{/snippet}
					Sign out
				</SidebarLink>
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
				<SidebarLink
					href="https://auth.{domain}/if/user/#/settings;%7B%22page%22%3A%22page-details%22%7D"
				>
					{#snippet icon(className: string)}
						<KeyRound class={className} />
					{/snippet}
					Change password
				</SidebarLink>
				<SidebarLink
					href="https://auth.{domain}/if/user/#/settings;%7B%22page%22%3A%22page-mfa%22%7D"
				>
					{#snippet icon(className: string)}
						<Fingerprint class={className} />
					{/snippet}
					Set up 2FA
				</SidebarLink>
			</ul>
		</aside>
		<Separator orientation="vertical" />
	</div>

	<main class="h-full w-full overflow-y-auto overflow-x-hidden px-20 py-8">
		{@render children()}
	</main>
</div>
