<script lang="ts">
	import { Skeleton } from "$lib/components/ui";
</script>

<div class="align-center group flex w-full flex-row items-center gap-2 rounded-md py-2">
	<Skeleton class="h-11 w-11 rounded-full" />
	<div>
		<Skeleton class="mb-2 h-4 w-36" />
		<Skeleton class="h-3 w-20" />
	</div>
</div>
