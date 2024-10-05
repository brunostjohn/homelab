<script lang="ts">
	import type { HTMLTableAttributes } from "svelte/elements";
	import { cn } from "$lib/utils.js";

	type $$Props = HTMLTableAttributes & { containerClass?: string };

	let className: $$Props["class"] = undefined;
	export { className as class };
	export let containerClass: $$Props["containerClass"] = undefined;
</script>

<div class={cn("relative w-full overflow-auto", containerClass)}>
	<table class={cn("w-full caption-bottom text-sm", className)} {...$$restProps}>
		<slot />
	</table>
</div>
