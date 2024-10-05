<script lang="ts">
	import type { SVGAttributes } from "svelte/elements";

	interface Props extends SVGAttributes<SVGSVGElement> {}

	const { ...rest }: Props = $props();
</script>

<svg {...rest} version="1.1" viewBox="0 0 256 256" id="svg3917">
	<defs id="defs3921" />

	<g id="logo" transform="matrix(2.4381018,0,0,2.4381018,128,128)">
		<g id="gear" mask="url(#holes)" stroke="#000">
			<path
				d="m-31.1718-33.813208 26.496029 74.188883h9.3515399l26.49603-74.188883h-9.767164l-16.728866 47.588948q-1.662496 4.571864-2.805462 8.624198-1.142966 3.948427-1.870308 7.585137-.72734199-3.63671-1.8703079-7.689043-1.142966-4.052334-2.805462-8.728104l-16.624959-47.381136z"
				fill="#000"
				stroke-width="4.51171"
				id="path3819"
			/>
			<circle transform="scale(-1,1)" r="43" fill="none" stroke-width="9" id="circle3821" />
			<g id="cogs" transform="scale(-1,1)">
				<polygon
					id="cog"
					points="51 0 46 -3 46 3"
					fill="#000"
					stroke="#000"
					stroke-linejoin="round"
					stroke-width="3"
				/>
				<g fill="#000" stroke="#000" id="g3886">
					<use transform="rotate(11.25)" xlink:href="#cog" id="use3824" />
					<use transform="rotate(22.5)" xlink:href="#cog" id="use3826" />
					<use transform="rotate(33.75)" xlink:href="#cog" id="use3828" />
					<use transform="rotate(45)" xlink:href="#cog" id="use3830" />
					<use transform="rotate(56.25)" xlink:href="#cog" id="use3832" />
					<use transform="rotate(67.5)" xlink:href="#cog" id="use3834" />
					<use transform="rotate(78.75)" xlink:href="#cog" id="use3836" />
					<use transform="rotate(90)" xlink:href="#cog" id="use3838" />
					<use transform="rotate(101.25)" xlink:href="#cog" id="use3840" />
					<use transform="rotate(112.5)" xlink:href="#cog" id="use3842" />
					<use transform="rotate(123.75)" xlink:href="#cog" id="use3844" />
					<use transform="rotate(135)" xlink:href="#cog" id="use3846" />
					<use transform="rotate(146.25)" xlink:href="#cog" id="use3848" />
					<use transform="rotate(157.5)" xlink:href="#cog" id="use3850" />
					<use transform="rotate(168.75)" xlink:href="#cog" id="use3852" />
					<use transform="scale(-1)" xlink:href="#cog" id="use3854" />
					<use transform="rotate(191.25)" xlink:href="#cog" id="use3856" />
					<use transform="rotate(202.5)" xlink:href="#cog" id="use3858" />
					<use transform="rotate(213.75)" xlink:href="#cog" id="use3860" />
					<use transform="rotate(225)" xlink:href="#cog" id="use3862" />
					<use transform="rotate(236.25)" xlink:href="#cog" id="use3864" />
					<use transform="rotate(247.5)" xlink:href="#cog" id="use3866" />
					<use transform="rotate(258.75)" xlink:href="#cog" id="use3868" />
					<use transform="rotate(-90)" xlink:href="#cog" id="use3870" />
					<use transform="rotate(-78.75)" xlink:href="#cog" id="use3872" />
					<use transform="rotate(-67.5)" xlink:href="#cog" id="use3874" />
					<use transform="rotate(-56.25)" xlink:href="#cog" id="use3876" />
					<use transform="rotate(-45)" xlink:href="#cog" id="use3878" />
					<use transform="rotate(-33.75)" xlink:href="#cog" id="use3880" />
					<use transform="rotate(-22.5)" xlink:href="#cog" id="use3882" />
					<use transform="rotate(-11.25)" xlink:href="#cog" id="use3884" />
				</g>
			</g>
			<g id="mounts" transform="scale(-1,1)">
				<polygon
					id="mount"
					points="0 -35 7 -42 -7 -42"
					fill="#000"
					stroke="#000"
					stroke-linejoin="round"
					stroke-width="6"
				/>
				<g fill="#000" stroke="#000" id="g3898">
					<use transform="rotate(72)" xlink:href="#mount" id="use3890" />
					<use transform="rotate(144)" xlink:href="#mount" id="use3892" />
					<use transform="rotate(216)" xlink:href="#mount" id="use3894" />
					<use transform="rotate(-72)" xlink:href="#mount" id="use3896" />
				</g>
			</g>
		</g>
		<mask id="holes">
			<rect x="-60" y="-60" width="120" height="120" fill="#fff" id="rect3902" />
			<circle id="hole" cy="-40" r="3" />
			<use transform="rotate(72)" xlink:href="#hole" id="use3905" />
			<use transform="rotate(144)" xlink:href="#hole" id="use3907" />
			<use transform="rotate(216)" xlink:href="#hole" id="use3909" />
			<use transform="rotate(-72)" xlink:href="#hole" id="use3911" />
		</mask>
	</g>
</svg>
