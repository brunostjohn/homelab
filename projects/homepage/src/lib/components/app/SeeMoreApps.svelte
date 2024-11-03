<script lang="ts">
	import { ChevronRight } from "lucide-svelte";
	import { Button } from "../ui";

	interface Props {
		description: string;
		href: string;
	}

	const { description, href }: Props = $props();
</script>

<Button variant="ghost" class="group h-full px-4 md:gap-6 lg:px-8" {href}>
	<div class="text-left">
		<p class="text-sm md:text-base lg:text-lg">See more apps</p>
		<p class="text-muted-foreground text-xs lg:text-base">{description}</p>
	</div>
	<ChevronRight
		class="text-muted-foreground group-hover:text-primary ml-auto h-6 min-h-6 w-6 min-w-6 transition-all group-hover:translate-x-1"
	/>
</Button>
