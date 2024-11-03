<script lang="ts">
	import { Avatar, Tooltip, Dropdown } from "$lib/components/ui";
	import { trpc } from "$lib/trpc";
	import { onMount } from "svelte";
	import UserMenuDropdownContent from "./UserMenuDropdownContent.svelte";
	import UserMenuSkeleton from "./UserMenuSkeleton.svelte";
	import { ChevronDown } from "lucide-svelte";
	import { cn } from "$lib/utils";

	const userQuery = trpc()?.user.createQuery();

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();

	let open = $state(false);

	onMount(() => {
		const handleOpenCommand = () => {
			open = false;
		};
		window.addEventListener("open-command", handleOpenCommand);

		return () => window.removeEventListener("open-command", handleOpenCommand);
	});
</script>

{#if $userQuery?.data}
	<Dropdown.Root bind:open>
		<Dropdown.Trigger asChild let:builder={dropdownBuilder}>
			<Tooltip.Root>
				<Tooltip.Trigger asChild let:builder={tooltipBuilder}>
					<button
						{...dropdownBuilder}
						use:dropdownBuilder.action
						{...tooltipBuilder}
						use:tooltipBuilder.action
						class="align-center hover:bg-muted/40 group ml-2 flex flex-row items-center gap-2 rounded-full p-2 transition-all md:ml-0 md:rounded-md xl:w-full"
					>
						<Avatar.Root class="aspect-square h-8 w-8 sm:h-10 sm:w-10">
							<Avatar.Fallback class="text-xs">
								{$userQuery.data.name
									.split(" ")
									.map((name) => name[0])
									.join("")}
							</Avatar.Fallback>
						</Avatar.Root>
						<div class="hidden text-left md:block">
							<p class="text-primary text-sm font-semibold">
								{$userQuery.data.name}
							</p>
							<p class="text-muted-foreground text-xs">
								{$userQuery.data.email}
							</p>
						</div>
						<ChevronDown
							class={cn(
								"text-muted-foreground ml-auto hidden size-5 transition-all xl:block",
								open ? "rotate-180" : ""
							)}
						/>
					</button>
				</Tooltip.Trigger>
				<Tooltip.Content class="z-[48]">
					<p>User menu</p>
				</Tooltip.Content>
			</Tooltip.Root>
		</Dropdown.Trigger>
		<UserMenuDropdownContent {domain} />
	</Dropdown.Root>
{:else}
	<UserMenuSkeleton />
{/if}
