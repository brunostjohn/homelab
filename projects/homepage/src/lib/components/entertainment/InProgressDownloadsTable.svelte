<script lang="ts">
	import { DownloadState, type InProgressDownload } from "$lib/trpc/routers/downloadClientsTypes";
	import { createTable, Subscribe, Render, createRender } from "svelte-headless-table";
	import { readable } from "svelte/store";
	import { Button, Table } from "$lib/components/ui";
	import { QBitTorrentIcon, SABnzbdIcon } from "../icons";
	import moment from "moment";
	import { filesize } from "filesize";
	import BadgePropWrapper from "./BadgePropWrapper.svelte";
	import MarqueeTextWrapper from "./MarqueeTextWrapper.svelte";
	import InProgressBar from "./InProgressBar.svelte";
	import { addPagination } from "svelte-headless-table/plugins";

	interface Props {
		downloads: InProgressDownload[];
	}

	const { downloads }: Props = $props();

	const table = createTable(readable(downloads), {
		page: addPagination({
			initialPageSize: 5,
		}),
	});

	const columns = table.createColumns([
		table.column({
			accessor: "name",
			header: "Name",
			// @ts-expect-error - incorrect type
			cell: ({ value }) => createRender(MarqueeTextWrapper, { text: value }),
		}),
		table.column({
			accessor: "state",
			header: "Status",
			cell: ({ value }) => {
				switch (value) {
					case DownloadState.Downloading:
						// @ts-expect-error - incorrect type
						return createRender(BadgePropWrapper, {
							class: "bg-green-300",
							text: "Downloading",
						});
					case DownloadState.Paused:
						// @ts-expect-error - incorrect type
						return createRender(BadgePropWrapper, {
							class: "bg-violet-300",
							text: "Paused",
						});
					case DownloadState.Processing:
						// @ts-expect-error - incorrect type
						return createRender(BadgePropWrapper, {
							class: "bg-yellow-300",
							text: "Processing",
						});
					case DownloadState.Queued:
						// @ts-expect-error - incorrect type
						return createRender(BadgePropWrapper, {
							text: "Queued",
						});
				}
			},
		}),
		table.column({
			accessor: ({ sizeBytes, downloadedBytes, downloadSpeedBytes, etaSeconds, progress }) => ({
				sizeBytes,
				downloadedBytes,
				downloadSpeedBytes,
				etaSeconds,
				progress,
			}),
			header: "Progress",
			// @ts-expect-error - incorrect type
			cell: ({ value }) => createRender(InProgressBar, value),
		}),
		table.column({
			accessor: ({ startedAtTimestamp }) =>
				startedAtTimestamp ? moment(new Date(startedAtTimestamp * 1000)).fromNow() : "Unknown",
			header: "Started",
		}),
		table.column({
			accessor: "type",
			header: "Type",
			cell: ({ value }) => {
				switch (value) {
					case "torrent":
						// @ts-expect-error - incorrect type
						return createRender(BadgePropWrapper, {
							class: "bg-blue-300",
							text: "Torrent",
						});
					case "nzb":
						// @ts-expect-error - incorrect type
						return createRender(BadgePropWrapper, {
							class: "bg-yellow-300",
							text: "NZB",
						});
				}
			},
		}),
		table.column({
			accessor: ({ sizeBytes }) => (sizeBytes ? filesize(sizeBytes) : "Unknown"),
			header: "Size",
		}),
	]);

	const {
		headerRows,
		pageRows,
		tableAttrs,
		tableBodyAttrs,
		pluginStates: {
			page: { hasNextPage, hasPreviousPage, pageIndex },
		},
	} = table.createViewModel(columns);
</script>

<div class="align-center mb-2 flex items-center">
	<h2 class="align-center flex items-center gap-2 text-xl font-semibold">
		<QBitTorrentIcon class="h-8 w-8 rounded-md" />
		<div class="h-[1.9rem] w-[1.9rem] rounded-[8px] bg-white p-1">
			<SABnzbdIcon class="relative h-full w-full" />
		</div>
		Downloads
	</h2>
</div>

<div>
	<div class="rounded-md border">
		<Table.Root {...$tableAttrs}>
			<Table.Header>
				{#each $headerRows as headerRow}
					<Subscribe rowAttrs={headerRow.attrs()}>
						<Table.Row>
							{#each headerRow.cells as cell (cell.id)}
								<Subscribe attrs={cell.attrs()} let:attrs props={cell.props()}>
									<Table.Head {...attrs}>
										<Render of={cell.render()} />
									</Table.Head>
								</Subscribe>
							{/each}
						</Table.Row>
					</Subscribe>
				{/each}
			</Table.Header>
			<Table.Body {...$tableBodyAttrs}>
				{#each $pageRows as row (row.id)}
					<Subscribe rowAttrs={row.attrs()} let:rowAttrs>
						<Table.Row {...rowAttrs}>
							{#each row.cells as cell (cell.id)}
								<Subscribe attrs={cell.attrs()} let:attrs>
									<Table.Cell {...attrs}>
										<Render of={cell.render()} />
									</Table.Cell>
								</Subscribe>
							{/each}
						</Table.Row>
					</Subscribe>
				{/each}
			</Table.Body>
		</Table.Root>
	</div>
	<div class="flex items-center justify-end space-x-4 py-4">
		<Button
			variant="outline"
			size="sm"
			on:click={() => ($pageIndex = $pageIndex - 1)}
			disabled={!$hasPreviousPage}>Previous</Button
		>
		<Button
			variant="outline"
			size="sm"
			disabled={!$hasNextPage}
			on:click={() => ($pageIndex = $pageIndex + 1)}>Next</Button
		>
	</div>
</div>
