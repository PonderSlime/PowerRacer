shader_type canvas_item;

render_mode blend_disabled;

uniform float size = 512.0;
uniform sampler2D input_texture;
uniform float dilation = 0.1;


vec4 pack_2x16_to_4x8(vec2 s) {
	return vec4(s.xy - vec2(mod(s.x, 1.0/256.0), mod(s.y, 1.0/256.0)) , vec2(mod(s.x, 1.0/256.0), mod(s.y, 1.0/256.0))*256.0);
}

float input_in(vec2 uv) {
	return (dot(texture(input_texture, uv).rgb, vec3(1.0))/3.0);
}

vec3 distance_h(vec2 uv) {
	vec2 e = vec2( 1.0 / size, 0.0);
	int steps = int( size * dilation );
	float rv = 0.0;
	vec2 source_uv;
	for (int i = 0; i < steps; ++i) {
		source_uv = uv + float(i) * e;
		if (input_in(source_uv) > 0.5) {
			rv = 1.0 - float(i) * e.x / dilation;
			break;
		}
		source_uv = uv - float(i) * e;
		if (input_in(source_uv) > 0.5) {
			rv = 1.0-float(i)*e.x/dilation;
			break;
		}
	}
	return vec3(rv, source_uv);
}

void fragment() {
	vec3 dilated_uv = distance_h((UV));
	COLOR = vec4(dilated_uv, 1.0);
	//COLOR = vec4(pack_2x16_to_4x8(dilated_uv.xy));
}