<script lang="ts">
	import { filesize } from "filesize";
	import { HardDrive } from "lucide-svelte";

	interface Props {
		pool: {
			name: string;
			allocated: number;
			size: number;
			status: string;
		};
	}

	const { pool }: Props = $props();
	const { name, allocated, size } = $derived(pool);
	const percent = $derived(Math.round((allocated / size) * 100));
</script>

<p class="mb-1 text-sm font-semibold">{name}</p>
<div class="bg-muted mb-1 h-2 min-h-2 w-full rounded-full">
	<div
		class="bg-muted-foreground h-full rounded-full transition-all"
		style="width: {percent}%;"
	></div>
</div>
<p class="text-muted-foreground align-center mb-2 flex items-center gap-1 text-xs">
	<HardDrive class="h-3 w-3" />{filesize(allocated)} / {filesize(size)} ({percent}%)
</p>
