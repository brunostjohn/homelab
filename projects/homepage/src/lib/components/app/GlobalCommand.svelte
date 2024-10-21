<script lang="ts">
	import { Command, Button } from "$lib/components/ui";
	import { Search } from "lucide-svelte";
	import { tick } from "svelte";

	let open = $state(false);

	const handleKeyDown = async (e: KeyboardEvent) => {
		e.preventDefault();

		if (e.key === "k" && (e.metaKey || e.ctrlKey)) {
			window.dispatchEvent(new CustomEvent("open-command"));
			await tick();
			open = true;
		}
	};
</script>

<svelte:window onkeydown={handleKeyDown} />

<Command.Dialog bind:open>
	<Command.Input placeholder="Type a command or search..." />
	<Command.List>
		<Command.Empty>No results found.</Command.Empty>
		<Command.Group heading="Suggestions">
			<Command.Item>Calendar</Command.Item>
			<Command.Item>Search Emoji</Command.Item>
			<Command.Item>Calculator</Command.Item>
		</Command.Group>
	</Command.List>
</Command.Dialog>

<Button
	variant="outline"
	class="group w-full justify-start px-2 md:ml-auto md:mr-2 md:max-w-64 xl:mb-2 xl:ml-0 xl:mr-0 xl:mt-auto xl:max-w-full"
	onclick={() => (open = !open)}
>
	<Search class="text-muted-foreground ml-1 mr-2 h-4 w-4" />
	<p class="text-muted-foreground">Search for an app...</p>
	<p
		class="text-muted-foreground group-hover:text-primary bg-muted ml-auto hidden rounded-md px-2 py-1 text-xs transition-all md:block"
	>
		⌘K
	</p>
</Button>
