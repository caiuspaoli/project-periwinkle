shader_type canvas_item;

uniform sampler2D strength_sampler;

void fragment() {
	float strength = texture(strength_sampler, UV).r;
	// Screen texture stores gaussian blurred copies on mipmaps.
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, (1.0 - strength) * 4.0).rgb;
	COLOR.rgb *= texture(strength_sampler, UV).rgb;
}