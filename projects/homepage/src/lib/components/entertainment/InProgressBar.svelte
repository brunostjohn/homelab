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
		<p class="text-xs text-muted-foreground">
			{filesize(downloadedBytes)} / {filesize(sizeBytes)}
		</p>
		{#if downloadSpeedBytes}
			<p class="text-xs text-muted-foreground">
				{filesize(downloadSpeedBytes)}/s
			</p>
		{/if}
	{/if}
	<div class="flex items-center gap-1">
		<div class="h-2 w-24 overflow-clip rounded-full bg-muted">
			<div
				class="h-2 animate-pulse rounded-full bg-muted-foreground"
				style="width: {progress}%"
			></div>
		</div>
		<p class="text-xs font-semibold text-muted-foreground">{Math.round(progress * 10) / 10}%</p>
	</div>
	{#if etaSeconds && etaSeconds < 60 * 60 * 24 * 7}
		<p class="text-xs text-muted-foreground">
			Done in {moment().add({ seconds: etaSeconds }).fromNow()}
		</p>
	{/if}
</div>
