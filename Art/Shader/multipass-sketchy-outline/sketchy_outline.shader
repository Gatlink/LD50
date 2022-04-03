/*
Copyright 2021 Ilaria Cislaghi

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

shader_type spatial;
render_mode cull_front, unshaded;

uniform sampler2D outline_noise_tex;
uniform vec4 outline_color:hint_color;
uniform float scissor_value = 0.5;
uniform vec2 uv_scale = vec2(1.0);
uniform sampler2D falloff_curve;
uniform float outline_size = 0.1;
uniform float offset_fres = 0.3;
uniform float fps = 5.0;

varying float h;

void vertex(){
	VERTEX += NORMAL * outline_size * texture(outline_noise_tex, UV).r;
	h = (WORLD_MATRIX * vec4(VERTEX, 1.0)).y;
}

void fragment(){
	float fres = abs(dot(normalize(-NORMAL), normalize(VERTEX)));
	vec3 nor = normalize(NORMAL);
	float angle = atan(nor.y, nor.x);
	angle /= 3.14;
	
	float fres_remap = texture(falloff_curve, vec2(1.0 - fres)).r + offset_fres;
	ALPHA = texture(outline_noise_tex, vec2(angle * uv_scale.x + SCREEN_UV.x, nor.z * uv_scale.y + floor(TIME * fps)/fps)).r * fres_remap;
	ALBEDO = outline_color.rgb;
	ALPHA_SCISSOR = scissor_value;
}