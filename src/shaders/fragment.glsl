#version 300 es
precision mediump float;

in vec2 uv;           // UV coordinate passed from vertex shader
out vec4 outColor;    // Final output color

void main() {
  outColor = vec4(uv.x, uv.y, 0.0, 1.0); // RGB from UV, full opacity
}