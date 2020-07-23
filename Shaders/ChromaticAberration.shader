shader_type canvas_item;

uniform sampler2D strength_sampler : hint_white;

void fragment() {
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	
	float strength = texture(strength_sampler, UV).r;
	float amount = texture(strength_sampler, UV).r / 100.0;
	color.r = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + amount, SCREEN_UV.y), 0.0).r;
	color.g = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).g;
	color.b = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x - amount, SCREEN_UV.y), 0.0).b;
		
	COLOR = color;
}