<script lang="ts">
	import type { Snippet } from "svelte";
	import GlobalCommand from "../GlobalCommand.svelte";
	import UserMenu from "../UserMenu.svelte";

	interface Props {
		children: Snippet;
		domain: string;
	}

	const { children, domain }: Props = $props();
</script>

<div class="relative mx-auto flex h-full w-full max-w-screen-lg flex-col">
	<aside
		class="align-center fixed left-0 top-0 z-[45] flex w-full items-center justify-center border-b p-2 px-4 backdrop-blur-xl backdrop-brightness-50 backdrop-saturate-150"
	>
		<div
			class="align-center mx-auto flex w-full items-center justify-center md:max-w-[85%] lg:max-w-[869px]"
		>
			<enhanced:img
				src="$lib/assets/icon.png"
				class="mr-4 min-w-10 max-w-10 sm:min-w-12 sm:max-w-12 md:mr-2"
				alt="Server Logo"
			/>
			<GlobalCommand />
			<UserMenu {domain} />
		</div>
	</aside>
	<main
		class="h-full w-full overflow-y-auto overflow-x-hidden px-5 py-4 pt-20 sm:mt-2 md:px-20 xl:mt-0"
	>
		{@render children()}
	</main>
</div>
