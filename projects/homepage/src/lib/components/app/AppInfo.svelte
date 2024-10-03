<script lang="ts">
	import { Button, Tooltip, Dialog } from "$lib/components/ui";
	import { Info } from "lucide-svelte";
	import AppInfoDialogContent from "./AppInfoDialogContent.svelte";

	interface Props {
		name: string;
	}

	const { name }: Props = $props();

	const handleClick = (e: MouseEvent) => {
		e.preventDefault();
	};
</script>

<Dialog.Root>
	<Dialog.Trigger asChild let:builder={dialogBuilder}>
		<Tooltip.Root>
			<Tooltip.Trigger asChild let:builder={tooltipBuilder}>
				<Button
					variant="ghost"
					class="ml-auto aspect-square h-8 w-8 rounded-full p-0 hover:bg-opacity-50"
					builders={[dialogBuilder, tooltipBuilder]}
					on:click={handleClick}
				>
					<Info class="h-5 w-5" />
				</Button>
			</Tooltip.Trigger>

			<Tooltip.Content class="bg-opacity-50 backdrop-blur-lg">
				<p>About {name}</p>
			</Tooltip.Content>
		</Tooltip.Root>
	</Dialog.Trigger>
	<Dialog.Content>
		<AppInfoDialogContent />
	</Dialog.Content>
</Dialog.Root>
