<script lang="ts">
	import type { SVGAttributes } from "svelte/elements";

	interface Props extends SVGAttributes<SVGSVGElement> {}

	const { ...rest }: Props = $props();
</script>

<svg {...rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 375 375"
	><defs
		><clipPath id="a"><path d="M36.488 0h302.25v302.25H36.488Zm0 0" /></clipPath><clipPath id="b"
			><path
				d="M187.613 0C104.13 0 36.488 67.64 36.488 151.125c0 83.484 67.64 151.125 151.125 151.125s151.125-67.64 151.125-151.125C338.738 67.641 271.098 0 187.613 0m0 252.133c-46.754 0-85.937-31.754-97.5-74.863 16.543-1.75 35.325-1.825 55.512 1.542l-.277.141c10.441 1.75 19.976 7.36 26.214 16.121l18.715 26.008c9.114 12.688 26.286 17.379 41.004 10.094 15.14-7.5 21.098-26.078 15.211-41.922-12.894-34.762-31.12-83.41-35.469-92.52-11.984-25.097-44.156-26.71-65.464-11.988-.282.207-.633.352-.91.563-.075.066-.145.066-.212.136-3.019 2.035-6.734 3.578-10.585 4.555-10.165 3.715-20.54 5.328-30.7 5.61 18.082-27.407 49.063-45.563 84.391-45.563 55.793 0 101.008 45.21 101.008 101.008 0 55.793-45.14 101.078-100.938 101.078m0 0"
			/></clipPath
		><clipPath id="d"><path d="M41.188 177.344h54.671v43.949H41.188Zm0 0" /></clipPath><clipPath
			id="e"
			><path
				d="M90.113 177.344c-20.328 2.097-37.363 6.726-48.925 10.722a145 145 0 0 0 5.183 16.473c.14.348.211.629.352.977 2.03 5.402 4.414 10.656 7.078 15.777 11.004-15.984 27.476-23.973 42.058-28.043-2.316-5.047-4.277-10.371-5.746-15.906m0 0"
			/></clipPath
		><clipPath id="f"><path d="M51.137 60.14h59.582v35.774H51.137Zm0 0" /></clipPath><clipPath
			id="g"
			><path
				d="M103.219 95.61c2.316-3.438 4.77-6.797 7.5-9.883h-.07S84.784 79.629 67.187 60.14a145 145 0 0 0-8.618 12.757l-.07.07a171 171 0 0 0-7.363 13.598c13.879 4.91 32.523 9.465 52.082 9.043m0 0"
			/></clipPath
		><linearGradient
			id="c"
			x1="284.943"
			x2="795.056"
			y1="687.257"
			y2="392.744"
			gradientTransform="translate(-190.9 -227.389)scale(.70095)"
			gradientUnits="userSpaceOnUse"
			><stop offset="0" stop-color="#3A00CD" /><stop offset=".125" stop-color="#3A00CD" /><stop
				offset=".133"
				stop-color="#3A00CD"
			/><stop offset=".137" stop-color="#3B00CD" /><stop offset=".141" stop-color="#3C00CE" /><stop
				offset=".144"
				stop-color="#3C00CE"
			/><stop offset=".148" stop-color="#3D00CE" /><stop offset=".152" stop-color="#3E00CF" /><stop
				offset=".156"
				stop-color="#3F00CF"
			/><stop offset=".16" stop-color="#4000CF" /><stop offset=".164" stop-color="#4100CF" /><stop
				offset=".168"
				stop-color="#4200D0"
			/><stop offset=".172" stop-color="#4300D0" /><stop offset=".18" stop-color="#4400D0" /><stop
				offset=".184"
				stop-color="#4500D1"
			/><stop offset=".188" stop-color="#4600D1" /><stop offset=".191" stop-color="#4700D1" /><stop
				offset=".195"
				stop-color="#4800D1"
			/><stop offset=".203" stop-color="#4800D2" /><stop offset=".207" stop-color="#4A00D2" /><stop
				offset=".211"
				stop-color="#4B00D2"
			/><stop offset=".215" stop-color="#4C00D2" /><stop offset=".219" stop-color="#4D00D3" /><stop
				offset=".223"
				stop-color="#4E00D3"
			/><stop offset=".227" stop-color="#4F00D3" /><stop offset=".231" stop-color="#5000D3" /><stop
				offset=".234"
				stop-color="#5000D4"
			/><stop offset=".238" stop-color="#5100D4" /><stop offset=".242" stop-color="#5200D4" /><stop
				offset=".246"
				stop-color="#5300D4"
			/><stop offset=".25" stop-color="#5400D5" /><stop offset=".254" stop-color="#5500D5" /><stop
				offset=".258"
				stop-color="#5600D6"
			/><stop offset=".266" stop-color="#5600D6" /><stop offset=".27" stop-color="#5800D6" /><stop
				offset=".273"
				stop-color="#5900D7"
			/><stop offset=".277" stop-color="#5A00D7" /><stop offset=".281" stop-color="#5B00D7" /><stop
				offset=".285"
				stop-color="#5C00D7"
			/><stop offset=".289" stop-color="#5C00D8" /><stop offset=".293" stop-color="#5D00D8" /><stop
				offset=".297"
				stop-color="#5E00D8"
			/><stop offset=".301" stop-color="#5F00D8" /><stop offset=".305" stop-color="#6000D9" /><stop
				offset=".309"
				stop-color="#6100D9"
			/><stop offset=".313" stop-color="#6200D9" /><stop offset=".316" stop-color="#6200DA" /><stop
				offset=".32"
				stop-color="#6300DA"
			/><stop offset=".324" stop-color="#6400DA" /><stop offset=".328" stop-color="#6500DA" /><stop
				offset=".332"
				stop-color="#6600DB"
			/><stop offset=".336" stop-color="#6700DB" /><stop offset=".34" stop-color="#6800DB" /><stop
				offset=".344"
				stop-color="#6900DB"
			/><stop offset=".348" stop-color="#6900DC" /><stop offset=".352" stop-color="#6A00DC" /><stop
				offset=".355"
				stop-color="#6B00DC"
			/><stop offset=".359" stop-color="#6C00DC" /><stop offset=".363" stop-color="#6D00DD" /><stop
				offset=".367"
				stop-color="#6E00DD"
			/><stop offset=".371" stop-color="#6E00DE" /><stop offset=".375" stop-color="#6F00DE" /><stop
				offset=".379"
				stop-color="#7000DE"
			/><stop offset=".383" stop-color="#7100DE" /><stop offset=".387" stop-color="#7200DF" /><stop
				offset=".391"
				stop-color="#7300DF"
			/><stop offset=".395" stop-color="#7400DF" /><stop offset=".398" stop-color="#7500DF" /><stop
				offset=".406"
				stop-color="#7600E0"
			/><stop offset=".41" stop-color="#7700E0" /><stop offset=".414" stop-color="#7800E0" /><stop
				offset=".418"
				stop-color="#7900E0"
			/><stop offset=".422" stop-color="#7A00E1" /><stop offset=".426" stop-color="#7B00E1" /><stop
				offset=".43"
				stop-color="#7C00E1"
			/><stop offset=".434" stop-color="#7C00E1" /><stop offset=".438" stop-color="#7D00E2" /><stop
				offset=".441"
				stop-color="#7E00E2"
			/><stop offset=".445" stop-color="#7F00E2" /><stop offset=".449" stop-color="#8000E2" /><stop
				offset=".453"
				stop-color="#8100E3"
			/><stop offset=".461" stop-color="#8200E3" /><stop offset=".465" stop-color="#8300E3" /><stop
				offset=".469"
				stop-color="#8400E4"
			/><stop offset=".473" stop-color="#8500E4" /><stop offset=".477" stop-color="#8600E4" /><stop
				offset=".48"
				stop-color="#8700E4"
			/><stop offset=".484" stop-color="#8800E5" /><stop offset=".488" stop-color="#8800E5" /><stop
				offset=".492"
				stop-color="#8900E6"
			/><stop offset=".496" stop-color="#8A00E6" /><stop offset=".5" stop-color="#8B00E6" /><stop
				offset=".504"
				stop-color="#8C00E6"
			/><stop offset=".508" stop-color="#8D00E7" /><stop offset=".512" stop-color="#8E00E7" /><stop
				offset=".516"
				stop-color="#8F00E7"
			/><stop offset=".519" stop-color="#9000E8" /><stop offset=".523" stop-color="#9000E8" /><stop
				offset=".527"
				stop-color="#9100E8"
			/><stop offset=".531" stop-color="#9200E8" /><stop offset=".535" stop-color="#9300E9" /><stop
				offset=".539"
				stop-color="#9400E9"
			/><stop offset=".543" stop-color="#9400E9" /><stop offset=".547" stop-color="#9500E9" /><stop
				offset=".551"
				stop-color="#9600EA"
			/><stop offset=".555" stop-color="#9700EA" /><stop offset=".559" stop-color="#9800EA" /><stop
				offset=".563"
				stop-color="#9900EA"
			/><stop offset=".566" stop-color="#9A00EB" /><stop offset=".57" stop-color="#9B00EB" /><stop
				offset=".574"
				stop-color="#9C00EB"
			/><stop offset=".578" stop-color="#9C00EB" /><stop offset=".582" stop-color="#9D00EC" /><stop
				offset=".586"
				stop-color="#9E00EC"
			/><stop offset=".59" stop-color="#9F00EC" /><stop offset=".594" stop-color="#A000EC" /><stop
				offset=".598"
				stop-color="#A100EC"
			/><stop offset=".602" stop-color="#A200ED" /><stop offset=".606" stop-color="#A200ED" /><stop
				offset=".609"
				stop-color="#A300ED"
			/><stop offset=".613" stop-color="#A400ED" /><stop offset=".617" stop-color="#A500EE" /><stop
				offset=".621"
				stop-color="#A600EE"
			/><stop offset=".625" stop-color="#A700EF" /><stop offset=".629" stop-color="#A800EF" /><stop
				offset=".633"
				stop-color="#A800EF"
			/><stop offset=".637" stop-color="#A900EF" /><stop offset=".641" stop-color="#AA00F0" /><stop
				offset=".644"
				stop-color="#AB00F0"
			/><stop offset=".648" stop-color="#AC00F0" /><stop offset=".652" stop-color="#AD00F0" /><stop
				offset=".656"
				stop-color="#AE00F1"
			/><stop offset=".664" stop-color="#AE00F1" /><stop offset=".668" stop-color="#B000F1" /><stop
				offset=".672"
				stop-color="#B100F2"
			/><stop offset=".676" stop-color="#B200F2" /><stop offset=".68" stop-color="#B300F2" /><stop
				offset=".684"
				stop-color="#B400F3"
			/><stop offset=".688" stop-color="#B500F3" /><stop offset=".691" stop-color="#B600F3" /><stop
				offset=".695"
				stop-color="#B600F3"
			/><stop offset=".699" stop-color="#B700F4" /><stop offset=".703" stop-color="#B800F4" /><stop
				offset=".707"
				stop-color="#B900F4"
			/><stop offset=".711" stop-color="#BA00F4" /><stop offset=".715" stop-color="#BA00F5" /><stop
				offset=".719"
				stop-color="#BB00F5"
			/><stop offset=".723" stop-color="#BC00F5" /><stop offset=".727" stop-color="#BD00F5" /><stop
				offset=".731"
				stop-color="#BE00F6"
			/><stop offset=".734" stop-color="#BF00F6" /><stop offset=".738" stop-color="#C000F7" /><stop
				offset=".742"
				stop-color="#C100F7"
			/><stop offset=".75" stop-color="#C200F7" /><stop offset=".754" stop-color="#C300F8" /><stop
				offset=".758"
				stop-color="#C400F8"
			/><stop offset=".762" stop-color="#C500F8" /><stop offset=".766" stop-color="#C600F8" /><stop
				offset=".769"
				stop-color="#C700F8"
			/><stop offset=".773" stop-color="#C800F9" /><stop offset=".777" stop-color="#C800F9" /><stop
				offset=".781"
				stop-color="#C900F9"
			/><stop offset=".785" stop-color="#CA00F9" /><stop offset=".789" stop-color="#CB00FA" /><stop
				offset=".793"
				stop-color="#CC00FA"
			/><stop offset=".797" stop-color="#CD00FA" /><stop offset=".801" stop-color="#CE00FA" /><stop
				offset=".805"
				stop-color="#CE00FB"
			/><stop offset=".809" stop-color="#CF00FB" /><stop offset=".813" stop-color="#D000FB" /><stop
				offset=".816"
				stop-color="#D100FB"
			/><stop offset=".82" stop-color="#D200FC" /><stop offset=".824" stop-color="#D300FC" /><stop
				offset=".828"
				stop-color="#D400FC"
			/><stop offset=".836" stop-color="#D400FC" /><stop offset=".84" stop-color="#D600FD" /><stop
				offset=".844"
				stop-color="#D700FD"
			/><stop offset=".848" stop-color="#D800FD" /><stop offset=".852" stop-color="#D900FE" /><stop
				offset=".856"
				stop-color="#DA00FE"
			/><stop offset=".859" stop-color="#DB00FF" /><stop offset=".863" stop-color="#DC00FF" /><stop
				offset=".867"
				stop-color="#DC00FF"
			/><stop offset=".875" stop-color="#DC00FF" /><stop
				offset="1"
				stop-color="#DC00FF"
			/></linearGradient
		></defs
	><g clip-path="url(#a)" transform="translate(-45.27)scale(1.2407)"
		><g clip-path="url(#b)"><path fill="url(#c)" d="M36.488 0v302.25h302.25V0Zm0 0" /></g></g
	><path
		fill="#fff"
		d="M173.935 146.276q0 .903-.175 1.784a9.2 9.2 0 0 1-1.366 3.29c-.33.5-.708.965-1.134 1.386a8.7 8.7 0 0 1-1.387 1.134q-.747.502-1.575.844a9 9 0 0 1-1.715.518 8.8 8.8 0 0 1-1.784.18 9 9 0 0 1-1.778-.18 8.7 8.7 0 0 1-1.711-.518 9.04 9.04 0 0 1-4.1-3.364 9.2 9.2 0 0 1-1.367-3.29 9.5 9.5 0 0 1-.17-1.784c0-.596.058-1.192.17-1.779a9 9 0 0 1 .523-1.71 9 9 0 0 1 .844-1.585 9.7 9.7 0 0 1 1.134-1.381q.64-.632 1.38-1.14a9.7 9.7 0 0 1 1.586-.843 9.4 9.4 0 0 1 1.71-.518 9.2 9.2 0 0 1 3.563 0 9.6 9.6 0 0 1 1.715.518 9.6 9.6 0 0 1 1.575.844q.755.507 1.387 1.139a9.1 9.1 0 0 1 1.977 2.966 9 9 0 0 1 .698 3.489m0 36.092a9.1 9.1 0 0 1-.698 3.494 8.7 8.7 0 0 1-.843 1.58 8.6 8.6 0 0 1-1.134 1.381 8.7 8.7 0 0 1-1.387 1.139q-.747.494-1.575.843a9.2 9.2 0 0 1-3.499.693 9.1 9.1 0 0 1-3.49-.693 9.7 9.7 0 0 1-1.584-.843 9.4 9.4 0 0 1-1.381-1.139 9.2 9.2 0 0 1-1.978-2.961 9 9 0 0 1-.523-1.716 9.5 9.5 0 0 1 0-3.562 9.3 9.3 0 0 1 .523-1.71q.343-.831.844-1.576a9 9 0 0 1 1.134-1.386 9 9 0 0 1 2.966-1.977 8.7 8.7 0 0 1 1.71-.519 9 9 0 0 1 1.78-.18c.605 0 1.196.059 1.783.18a9 9 0 0 1 1.715.519 9 9 0 0 1 1.575.843c.504.33.965.712 1.387 1.134a8.7 8.7 0 0 1 1.134 1.386c.334.495.615 1.023.843 1.575.233.558.402 1.125.523 1.711q.175.888.175 1.784m-18.092-18.088q0 .897-.175 1.784a9.3 9.3 0 0 1-.518 1.71 9.5 9.5 0 0 1-.843 1.576q-.501.751-1.14 1.386a8.6 8.6 0 0 1-1.38 1.134c-.5.34-1.023.62-1.58.843a8.8 8.8 0 0 1-1.716.519 8.8 8.8 0 0 1-1.779.18 9 9 0 0 1-1.783-.18 9 9 0 0 1-1.711-.519 8.2 8.2 0 0 1-1.575-.843 8.9 8.9 0 0 1-2.52-2.52 8.2 8.2 0 0 1-.844-1.575 9.3 9.3 0 0 1-.523-1.71 9.2 9.2 0 0 1 0-3.563c.121-.591.29-1.163.523-1.716.223-.557.504-1.08.844-1.58q.496-.75 1.129-1.38a9 9 0 0 1 1.39-1.14 9.5 9.5 0 0 1 1.576-.843 9.3 9.3 0 0 1 1.71-.519 9.2 9.2 0 0 1 3.563 0 9.1 9.1 0 0 1 3.295 1.362q.75.501 1.382 1.14.638.63 1.139 1.38a9.1 9.1 0 0 1 1.536 5.074m36.092 0q0 .897-.175 1.784a9 9 0 0 1-.523 1.71 8.2 8.2 0 0 1-.844 1.576 8.9 8.9 0 0 1-2.52 2.52 8.2 8.2 0 0 1-1.575.843 9 9 0 0 1-1.71.519 9 9 0 0 1-1.784.18 8.8 8.8 0 0 1-1.779-.18 8.8 8.8 0 0 1-1.715-.519 8.3 8.3 0 0 1-1.58-.843 8.6 8.6 0 0 1-1.382-1.134 9 9 0 0 1-1.139-1.386 9.5 9.5 0 0 1-.843-1.575 9.3 9.3 0 0 1-.518-1.71 9.2 9.2 0 0 1 0-3.563 9.1 9.1 0 0 1 1.361-3.296q.501-.75 1.14-1.38a9 9 0 0 1 1.38-1.14 9.1 9.1 0 0 1 5.074-1.536c.602 0 1.193.058 1.784.174q.882.176 1.711.519.831.35 1.575.843a9 9 0 0 1 2.52 2.52c.34.5.62 1.023.844 1.58q.349.83.523 1.716.175.878.175 1.779m0 0"
	/><g clip-path="url(#d)" transform="matrix(1.25036 0 0 1.24183 -46.065 -.325)"
		><g clip-path="url(#e)"
			><path d="M40.764 177.344v44.09h55.095v-44.09zm0 0" style="fill:#fff" /></g
		></g
	><g clip-path="url(#f)" transform="matrix(1.25008 0 0 1.24758 -46.214 -.66)"
		><g clip-path="url(#g)"
			><path d="M51.137 60.14v35.774h59.582V60.141Zm0 0" style="fill:#fff" /></g
		></g
	></svg
>
