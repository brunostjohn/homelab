<script lang="ts">
	import type { SVGAttributes } from "svelte/elements";

	interface Props extends SVGAttributes<SVGSVGElement> {}

	const { ...rest }: Props = $props();
</script>

<svg
	{...rest}
	viewBox="0 0 608 608"
	xmlns="http://www.w3.org/2000/svg"
	fill-rule="evenodd"
	clip-rule="evenodd"
	stroke-linejoin="round"
	stroke-miterlimit="1.414"
	><path
		d="M630.988 320.63V188.324h99.863v-35.62l110.197 101.773L730.85 356.25v-35.62h-99.86z"
		fill="none"
		stroke-width="16.62"
		stroke="#000"
		transform="matrix(0 2.665 -2.7482 0 1003.016 -1657.67)"
	/><path
		d="M121.86 23.913h363.604v266.135h97.89l-279.69 293.667L23.97 290.048h97.89V23.913z"
		fill="#FFB300"
		class="logo-arrow-outer"
	/><path
		d="M303.664 583.797L122.274 23.975h362.78l-181.39 559.822z"
		class="logo-arrow-inner"
		fill="#FFCA28"
	/></svg
>
