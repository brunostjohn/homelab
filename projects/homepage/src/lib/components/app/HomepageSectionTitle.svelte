<script lang="ts">
	import type { Snippet } from "svelte";
	import HomepageSectionTitleHeading from "./HomepageSectionTitleHeading.svelte";
	import HomepageSectionSeeMore from "./HomepageSectionSeeMore.svelte";

	interface BaseProps {
		title: string;
		titleIcon?: Snippet<[string]>;
		seeMoreHref?: string;
		seeMoreIcon?: Snippet<[string]>;
		seeMoreAppName?: string;
	}

	interface SeeMoreProps extends BaseProps {
		title: string;
		titleIcon: Snippet<[string]>;
		seeMoreHref: string;
		seeMoreIcon: Snippet<[string]>;
		seeMoreAppName: string;
	}

	interface NoSeeMoreProps extends BaseProps {
		title: string;
		titleIcon?: Snippet<[string]>;
	}

	type Props = SeeMoreProps | NoSeeMoreProps;

	const { title, titleIcon, seeMoreHref, seeMoreIcon, seeMoreAppName }: Props = $props();
</script>

{#if seeMoreHref && seeMoreIcon && seeMoreAppName}
	<div class="align-center mb-4 flex flex-col sm:flex-row sm:items-center sm:justify-center">
		<HomepageSectionTitleHeading {titleIcon}>
			{title}
		</HomepageSectionTitleHeading>

		<HomepageSectionSeeMore href={seeMoreHref} {seeMoreIcon} {seeMoreAppName} />
	</div>
{:else}
	<HomepageSectionTitleHeading {titleIcon} class="mb-4 mt-8">
		{title}
	</HomepageSectionTitleHeading>
{/if}
