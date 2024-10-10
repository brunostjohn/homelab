<script lang="ts">
	import { onMount } from "svelte";

	let canvas: HTMLCanvasElement;

	onMount(() => {
		const context = canvas.getContext("2d");
		if (!context) return;
		let time = 0;

		const color = (x: number, y: number, r: number, g: number, b: number) => {
			context.fillStyle = `rgb(${r}, ${g}, ${b})`;
			context.fillRect(x, y, 10, 10);
		};

		const R = (x: number, y: number, time: number) =>
			Math.floor(192 + 64 * Math.cos((x * x - y * y) / 300 + time));

		const G = (x: number, y: number, time: number) =>
			Math.floor(
				192 + 64 * Math.sin((x * x * Math.cos(time / 4) + y * y * Math.sin(time / 3)) / 300)
			);

		const B = (x: number, y: number, time: number) =>
			Math.floor(
				192 +
					64 *
						Math.sin(
							5 * Math.sin(time / 9) + ((x - 100) * (x - 100) + (y - 100) * (y - 100)) / 1100
						)
			);

		const startAnimation = () => {
			for (let x = 0; x <= 30; x++) {
				for (let y = 0; y <= 30; y++) {
					color(x, y, R(x, y, time), G(x, y, time), B(x, y, time));
				}
			}
			time = time + 0.01;
			window.requestAnimationFrame(startAnimation);
		};

		startAnimation();
	});

	interface Props {
		class?: string;
	}

	const { class: className }: Props = $props();
</script>

<canvas class={className} bind:this={canvas} width="32px" height="32px"></canvas>
