<script lang="ts">
	import type { SVGAttributes } from "svelte/elements";

	interface Props extends SVGAttributes<SVGSVGElement> {}

	const { ...rest }: Props = $props();
</script>

<svg {...rest} viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
        d="M6 10.8676L8.75329 13.6226V17.9842H6V10.8676ZM17.5645 5.01046V17.535C17.5645 17.7921 17.3548 18 17.0977 18C16.9744 18 16.8563 17.9525 16.7683 17.8644L6 8.15303V5.40504C6 5.14785 6.20787 4.94 6.46505 4.94H6.48972C6.61303 4.94 6.7328 4.98933 6.81911 5.07564L14.8094 12.009V5.01046H17.5645Z"
        fill="url(#paint0_linear_231_10218)" />
    <path fill-rule="evenodd" clip-rule="evenodd"
        d="M3 0C1.34315 0 0 1.34315 0 3V21C0 22.6569 1.34315 24 3 24H21C22.6569 24 24 22.6569 24 21V3C24 1.34315 22.6569 0 21 0H3ZM3.63333 2.13333C2.8049 2.13333 2.13333 2.8049 2.13333 3.63333V20.3667C2.13333 21.1951 2.8049 21.8667 3.63333 21.8667H20.3667C21.1951 21.8667 21.8667 21.1951 21.8667 20.3667V3.63333C21.8667 2.8049 21.1951 2.13333 20.3667 2.13333H3.63333Z"
        fill="url(#paint1_linear_231_10218)" />
    <defs>
        <linearGradient id="paint0_linear_231_10218" x1="11.7814" y1="0.543214" x2="11.7814" y2="21.6612"
            gradientUnits="userSpaceOnUse">
            <stop stop-color="#4351E8" />
            <stop offset="1" stop-color="#2A1EA5" />
        </linearGradient>
        <linearGradient id="paint1_linear_231_10218" x1="4.82267" y1="19.1431" x2="26.7035" y2="-2.6331"
            gradientUnits="userSpaceOnUse">
            <stop stop-color="#4351E8" />
            <stop offset="1" stop-color="#2A1EA5" />
        </linearGradient>
    </defs>
</svg>