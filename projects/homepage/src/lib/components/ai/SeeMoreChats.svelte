<script lang="ts">
	import { ChevronRight } from "lucide-svelte";

	interface Props {
		domain: string;
	}

	const { domain }: Props = $props();
</script>

<a href="https://ollama.{domain}" class="group contents">
	<div
		class="align-center group-hover:bg-muted flex items-center justify-center p-4 transition-all"
	>
		<div>
			<p class="font-semibold">See more</p>
			<p class="text-muted-foreground text-sm">Chat with AI, use tools, search the web.</p>
		</div>

		<ChevronRight
			class="text-muted-foreground group-hover:text-primary ml-auto h-6 w-6 transition-all group-hover:translate-x-1"
		/>
	</div>
</a>
