<script lang="ts">
	import { Card } from "$lib/components/ui";
	import { cn } from "$lib/utils";
	import AppInfo from "./AppInfo.svelte";
	import type { Snippet } from "svelte";

	interface Props {
		name: string;
		description: string;
		href: string;
		gradientColours?: [string, string, string];
		icon: Snippet<[string]>;
		notInList?: boolean;
		children?: Snippet;
		class?: string;
	}

	const {
		name,
		description,
		href,
		gradientColours,
		icon,
		notInList,
		children,
		class: className,
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
	<a {href} class="contents">
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
	</a>
{/snippet}

{#if notInList}
	{@render content()}
{:else}
	<li>
		{@render content()}
	</li>
{/if}
