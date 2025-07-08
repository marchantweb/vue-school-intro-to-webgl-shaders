<template>
  <canvas ref="canvas"></canvas>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import vertexShaderSrc from '../shaders/vertex.glsl?raw';
import fragmentShaderSrc from '../shaders/fragment.glsl?raw';

const canvas = ref();
let gl, program, animationFrame;

onMounted(() => {
  gl = canvas.value.getContext('webgl2');
  if (!gl) {
    console.error('WebGL2 not supported');
    return;
  }

  // Compile and link program
  const vertexShader = compileShader(gl.VERTEX_SHADER, vertexShaderSrc);
  const fragmentShader = compileShader(gl.FRAGMENT_SHADER, fragmentShaderSrc);
  program = linkProgram(vertexShader, fragmentShader);
  gl.useProgram(program);

  // Setup triangle index buffer for vertex.glsl
  const indexLoc = gl.getAttribLocation(program, 'index');
  const indexBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, indexBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Int32Array([0, 1, 2]), gl.STATIC_DRAW);
  gl.enableVertexAttribArray(indexLoc);
  gl.vertexAttribIPointer(indexLoc, 1, gl.INT, 0, 0);

  // Watch the window to resize
  handleResize();
  window.addEventListener('resize', handleResize);

  // Render time!
  const render = () => {
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
    gl.clear(gl.COLOR_BUFFER_BIT);
    gl.drawArrays(gl.TRIANGLES, 0, 3);
    animationFrame = requestAnimationFrame(render);
  };

  render();
});

onUnmounted(() => {
  cancelAnimationFrame(animationFrame);
  window.removeEventListener('resize', handleResize);
  if (gl && program) {
    gl.deleteProgram(program);
  }
});

function handleResize() {
  const canvasEl = canvas.value;
  const dpr = window.devicePixelRatio || 1;
  canvasEl.width = canvasEl.clientWidth * dpr;
  canvasEl.height = canvasEl.clientHeight * dpr;
  gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
}

function compileShader(type, source) {
  const shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);
  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    console.error(gl.getShaderInfoLog(shader));
    return null;
  }
  return shader;
}

function linkProgram(vertexShader, fragmentShader) {
  const program = gl.createProgram();
  gl.attachShader(program, vertexShader);
  gl.attachShader(program, fragmentShader);
  gl.linkProgram(program);
  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.error(gl.getProgramInfoLog(program));
    return null;
  }
  return program;
}
</script>

<style scoped>
canvas {
  display: block;
  width: 100%;
  aspect-ratio: 3/2;
}
</style>
