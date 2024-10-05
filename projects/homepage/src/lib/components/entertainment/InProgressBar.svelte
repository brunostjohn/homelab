<script lang="ts">
	import { filesize } from "filesize";
	import moment from "moment";

	interface Props {
		progress: number;
		sizeBytes: number;
		downloadedBytes: number;
		downloadSpeedBytes: number;
		etaSeconds: number;
	}

	const { progress, sizeBytes, downloadedBytes, downloadSpeedBytes, etaSeconds }: Props = $props();
</script>

<div class="flex flex-col">
	{#if sizeBytes}
		<p class="text-muted-foreground text-xs">
			{filesize(downloadedBytes)} / {filesize(sizeBytes)}{#if downloadSpeedBytes}
				- {filesize(downloadSpeedBytes)}/s{/if}
		</p>
	{/if}
	<div class="flex items-center gap-1">
		<div class="bg-muted h-2 w-24 overflow-clip rounded-full">
			<div
				class="bg-muted-foreground h-2 animate-pulse rounded-full"
				style="width: {progress}%"
			></div>
		</div>
		<p class="text-muted-foreground text-xs font-semibold">{Math.round(progress * 10) / 10}%</p>
	</div>
	{#if etaSeconds && etaSeconds < 60 * 60 * 24 * 7}
		<p class="text-muted-foreground text-xs">
			Done in {moment().add({ seconds: etaSeconds }).fromNow()}
		</p>
	{/if}
</div>
