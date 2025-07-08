#version 300 es

in int index;       // Per-vertex index: 0, 1, or 2
out vec2 uv;        // UV coordinate passed to fragment shader

void main() {
  // Define the 3 corners of a full-screen triangle in clip space
  vec2 positions[3];
  positions[0] = vec2(-1.0, -1.0); // bottom-left
  positions[1] = vec2(3.0, -1.0);  // bottom-right (overshoots)
  positions[2] = vec2(-1.0, 3.0);  // top-left (overshoots)

  // Select one of the three positions based on index
  vec2 pos = positions[index];

  // Set vertex position
  gl_Position = vec4(pos, 0.0, 1.0);

  // Convert clip-space [-1, 1] to UV space [0, 1]
  uv = pos * 0.5 + 0.5;
}