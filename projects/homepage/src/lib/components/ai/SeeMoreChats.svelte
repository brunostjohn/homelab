<script lang="ts">
	import { ChevronRight } from "lucide-svelte";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();
</script>

<a href="https://ollama.{domain}" class="group contents">
	<div
		class="align-center relative flex items-center justify-center p-4 backdrop-blur-lg backdrop-brightness-50 backdrop-saturate-150 transition-all group-hover:bg-muted/30 group-hover:backdrop-brightness-[60%]"
	>
		<div>
			<p class="font-semibold">See more</p>
			<p class="text-sm text-muted-foreground">Chat with AI, use tools, search the web.</p>
		</div>

		<ChevronRight
			class="ml-auto h-6 w-6 text-muted-foreground transition-all group-hover:translate-x-1 group-hover:text-primary"
		/>
	</div>
</a>
