<script lang="ts">
	import { Dropdown } from "$lib/components/ui";
	import { LogOut, KeyRound, Fingerprint, Aperture, Cable, BookOpenText } from "lucide-svelte";
	import { onDestroy } from "svelte";
	import { createMediaStore } from "svelte-media-queries";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	const matches = createMediaStore("(max-width: 1280px)");
	onDestroy(() => matches.destroy());
</script>

<Dropdown.Content class="z-[49] min-w-56">
	{#if $matches}
		<Dropdown.Item class="p-3 md:px-2 md:py-1.5">
			<Cable class="mr-2 h-4 w-4" />
			<span>Uptime status</span>
		</Dropdown.Item>
		<Dropdown.Item class="p-3 md:px-2 md:py-1.5">
			<BookOpenText class="mr-2 h-4 w-4" />
			<span>Documentation</span>
		</Dropdown.Item>
		<Dropdown.Separator />
	{/if}
	<Dropdown.Item class="p-3 md:px-2 md:py-1.5">
		<Aperture class="mr-2 h-4 w-4" />
		<span>Set profile picture</span>
	</Dropdown.Item>
	<Dropdown.Item
		class="p-3 md:px-2 md:py-1.5"
		href="https://auth.{domain}/if/user/#/settings;%7B%22page%22%3A%22page-details%22%7D"
	>
		<KeyRound class="mr-2 h-4 w-4" />
		<span>Change password</span>
	</Dropdown.Item>
	<Dropdown.Item
		href="https://auth.{domain}/if/user/#/settings;%7B%22page%22%3A%22page-mfa%22%7D"
		class="p-3 md:px-2 md:py-1.5"
	>
		<Fingerprint class="mr-2 h-4 w-4" />
		<span>Set up 2FA</span>
	</Dropdown.Item>
	<Dropdown.Separator />
	<Dropdown.Item href="https://{domain}/signout" class="p-3 md:px-2 md:py-1.5">
		<LogOut class="mr-2 h-4 w-4" />
		<span>Sign out</span>
	</Dropdown.Item>
</Dropdown.Content>
