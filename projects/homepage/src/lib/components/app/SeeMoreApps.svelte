<script lang="ts">
	import { ChevronRight } from "lucide-svelte";
	import { Button } from "../ui";

	interface Props {
		description: string;
		href: string;
	}

	const { description, href }: Props = $props();
</script>

<Button variant="ghost" class="group h-full gap-6" {href}>
	<div class="text-left">
		<p class="text-lg">See more apps</p>
		<p class="text-muted-foreground">{description}</p>
	</div>
	<ChevronRight class="h-6 w-6 transition-all group-hover:translate-x-1" />
</Button>
