<script lang="ts">
	import { getMessage } from "$lib";
	import type { PageServerData } from "./$types";

	interface Props {
		data: PageServerData;
	}

	const { data }: Props = $props();
	const { staticUrl: staticPreprocessed, homepageUrl, errorCode } = $derived(data);
	const staticUrl = $derived(
		staticPreprocessed?.endsWith("/") ? staticPreprocessed : staticPreprocessed + "/"
	);
	const { title, subtitle } = $derived(getMessage(errorCode));
</script>

<a href={homepageUrl} id="homepageLink"> ← Go home </a>
<a href={homepageUrl} aria-labelledby="homepageLink">
	<img src="{staticUrl}images/server-icon.png" alt="Server icon" />
</a>

<h1>{errorCode}</h1>
<h2>{title}</h2>
<p>{subtitle}</p>

<style>
	img {
		width: 150px;
		height: 150px;
		margin-bottom: 1rem;
	}

	h1,
	h2,
	p {
		margin: 0;
	}

	h1 {
		font-size: 5rem;
		font-weight: 800;
		margin-bottom: 0.5rem;
	}

	h2 {
		font-size: 2rem;
		font-weight: 600;
		margin-bottom: 0.5rem;
	}

	a {
		text-decoration: underline;
		text-decoration-color: transparent;
		color: #ffffff75;

		transition: text-decoration-color 0.3s;
	}

	a:hover {
		text-decoration-color: #ffffff75;
	}
</style>
