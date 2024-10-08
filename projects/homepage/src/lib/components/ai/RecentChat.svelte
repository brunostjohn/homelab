<script lang="ts">
	import { cn } from "$lib/utils";
	import { ChevronRight } from "lucide-svelte";
	import moment from "moment";

	interface Chat {
		id: string;
		title: string;
		updated_at: number;
		created_at: number;
		chat?: Record<string | number, unknown> | undefined;
		user_id?: string | undefined;
		share_id?: (string | null) | undefined;
		archived?: boolean | undefined;
	}

	interface Message {
		content: string;
		lastSentence: string;
		modelName: string;
		role: "user" | "assistant";
	}

	interface Props {
		domain: string;
		chat: Chat;
		i: number;
		count: number;
	}

	const { domain, chat, i, count }: Props = $props();
	const isOdd = $derived(i % 2 === 0);
	const isFirstRow = $derived(i === 0 || i === 1);
	const isLastRow = $derived(i === count - 1 || (i === count - 2 && count % 2 === 0));
	const { id, title, updated_at, chat: chatData } = $derived(chat);
	const messages = $derived(chatData?.messages as Message[] | undefined);
	const lastMessage = $derived(messages?.[messages.length - 1]);
</script>

<a href="https://ollama.{domain}/c/{id}" class="group contents">
	<div
		class={cn(
			"flex gap-2 px-4 py-4",
			"group-hover:bg-muted transition-all",
			isOdd ? "border-r" : "",
			isLastRow ? "" : "border-b",
			isFirstRow && isOdd ? "rounded-tl-md" : "",
			isFirstRow && !isOdd ? "rounded-tr-md" : "",
			isLastRow && isOdd ? "rounded-bl-md" : "",
			isLastRow && !isOdd ? "rounded-br-md" : ""
		)}
	>
		<div class="overflow-hidden">
			<p class="text-muted-foreground text-xs font-semibold">
				{moment(updated_at * 1000).fromNow()}
			</p>
			<p class="max-w-full overflow-hidden text-ellipsis whitespace-nowrap text-nowrap">{title}</p>
			{#if lastMessage}
				<div class="text-muted-foreground align-center flex items-center gap-1">
					<p class="w-fit text-nowrap text-xs font-semibold">
						{lastMessage.role === "user" ? "You" : lastMessage.modelName}:
					</p>
					<p class="max-w-full overflow-hidden text-ellipsis whitespace-nowrap text-nowrap text-sm">
						{lastMessage.content.split("\n")[0]}
					</p>
				</div>
			{/if}
		</div>
		<ChevronRight
			class="text-muted-foreground group-hover:text-primary my-auto ml-auto h-6 min-h-6 w-6 min-w-6 transition-all group-hover:translate-x-1"
		/>
	</div>
</a>
