<script lang="ts">
	import { Card, Dialog, Separator } from "$lib/components/ui";
	import { cn } from "$lib/utils";
	import { ChevronRight } from "lucide-svelte";
	import AppInfo from "./AppInfo.svelte";
	import type { Snippet } from "svelte";

	interface Instance {
		name: string;
		href: string;
	}

	interface Props {
		name: string;
		description: string;
		gradientColours?: [string, string, string];
		icon: Snippet<[string]>;
		notInList?: boolean;
		children?: Snippet;
		class?: string;
		instances: Instance[];
	}

	const {
		name,
		description,
		gradientColours,
		icon,
		notInList,
		children,
		class: className,
		instances,
	}: Props = $props();

	const style = gradientColours
		? `
      background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), linear-gradient(90deg, ${gradientColours[0]} 0%, ${gradientColours[1]} 50%, ${gradientColours[2]} 100%);
    `
		: undefined;
</script>

{#snippet cardContent()}
	{@render icon("h-8 w-8 md:h-10 md:w-10 my-auto rounded-md")}
	<div>
		<h2 class="text-sm font-medium md:text-lg">{name}</h2>
		<p class="text-muted-foreground text-xs md:text-sm">
			{description}
		</p>
	</div>
	<AppInfo {name} />
{/snippet}

{#snippet content()}
	<Dialog.Root>
		<Dialog.Trigger asChild let:builder>
			<button {...builder} use:builder.action class="contents text-left">
				<Card.Root
					class={cn(
						"hover:border-muted-foreground group transition-all",
						notInList ? "" : "h-full",
						className
					)}
					{style}
				>
					<Card.Content
						class="align-center flex h-full items-center gap-3 p-3 sm:p-2 sm:py-3 md:gap-4 md:p-4"
					>
						{#if children}
							<div class="flex h-full flex-col">
								{@render cardContent()}
								{@render children()}
							</div>
						{:else}
							{@render cardContent()}
						{/if}
					</Card.Content>
				</Card.Root>
			</button>
		</Dialog.Trigger>
		<Dialog.Content>
			<Dialog.Header>
				<Dialog.Title class="mb-1 text-xl">Select {name} instance.</Dialog.Title>
			</Dialog.Header>
			<ul>
				{#each instances as instance}
					<li class="group mt-4 first:mt-0">
						<a
							class="group contents"
							href={instance.href}
							target="_blank"
							rel="noopener noreferrer"
						>
							<div class="align-center flex items-center justify-between">
								<div>
									<p class="text-base font-semibold">
										{instance.name}
									</p>
									<p class="text-muted-foreground text-xs">{instance.href}</p>
								</div>
								<ChevronRight
									class="text-muted-foreground group-hover:text-primary size-6 transition-all group-hover:translate-x-1"
								/>
							</div>
						</a>
						<Separator class="mt-4 group-last:hidden" />
					</li>
				{/each}
			</ul>
		</Dialog.Content>
	</Dialog.Root>
{/snippet}

{#if notInList}
	{@render content()}
{:else}
	<li>
		{@render content()}
	</li>
{/if}
