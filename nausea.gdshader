shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 uv = SCREEN_UV;
	
	uv.x += sin(uv.y * 8.0 + TIME * 4.0) * 0.03;
	uv.y += cos(uv.x * 8.0 + TIME * 4.0) * 0.03;
	
	float r = texture(SCREEN_TEXTURE, vec2(uv.x + 0.015, uv.y)).r;
	float g = texture(SCREEN_TEXTURE, uv).g;
	float b = texture(SCREEN_TEXTURE, vec2(uv.x - 0.015, uv.y)).b;
	
	COLOR = vec4(r, g, b, 1.0);
}