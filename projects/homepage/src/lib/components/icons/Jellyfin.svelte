<script lang="ts">
	import type { SVGAttributes } from "svelte/elements";

	interface Props extends SVGAttributes<SVGSVGElement> {}

	const { ...rest }: Props = $props();
</script>

<svg
	{...rest}
	viewBox="0 0 1024 1024"
	version="1.1"
	xmlns="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
>
	<title>primary</title>
	<defs>
		<linearGradient
			x1="19.2532352%"
			y1="40.8257212%"
			x2="100.658798%"
			y2="88.6971024%"
			id="linearGradient-1"
		>
			<stop stop-color="#1F4EA7" offset="0%"></stop>
			<stop stop-color="#00DDFF" offset="100%"></stop>
		</linearGradient>
	</defs>
	<g id="Primary" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
		<g id="primary" fill-rule="nonzero">
			<rect id="solid-background" fill="#020B23" x="0" y="0" width="1024" height="1024"></rect>
			<path
				d="M511.582082,136 C609.711866,136 924.91518,714.816848 877.299462,811.251498 C829.683744,907.686149 194.101496,908.81122 145.960253,811.251498 C97.8190104,713.691777 413.547848,136 511.582082,136 Z M511.677632,288.155769 C447.420301,288.155769 240.55469,666.677846 272.102093,730.597947 C303.649497,794.518049 720.072042,793.810861 751.269096,730.597947 C782.46615,667.368961 575.934964,288.155769 511.677632,288.155769 Z M511.109544,425.091384 C543.724099,425.107443 648.323295,617.009305 632.517902,648.998301 C616.71251,680.987298 405.681839,681.34059 389.701185,648.998301 C373.720531,616.656013 478.542787,425.091384 511.109544,425.091384 Z"
				id="Combined-Shape"
				fill="url(#linearGradient-1)"
			></path>
		</g>
	</g>
</svg>
