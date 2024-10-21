<script lang="ts">
	import { ChevronRight } from "lucide-svelte";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();
</script>

<a href="https://ollama.{domain}" class="group contents">
	<div
		class="align-center group-hover:bg-muted/30 relative flex items-center justify-center p-3 backdrop-blur-lg backdrop-brightness-50 backdrop-saturate-150 transition-all group-hover:backdrop-brightness-[60%] md:p-4"
	>
		<div>
			<p class="text-sm font-semibold md:text-base">See more</p>
			<p class="text-muted-foreground text-xs md:text-sm">
				Chat with AI, use tools, search the web.
			</p>
		</div>

		<ChevronRight
			class="text-muted-foreground group-hover:text-primary ml-auto h-6 w-6 transition-all group-hover:translate-x-1"
		/>
	</div>
</a>
