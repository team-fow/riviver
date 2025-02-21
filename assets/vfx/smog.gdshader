shader_type canvas_item;

uniform sampler2D pattern;


void fragment() {
	COLOR.rgb = texture(pattern, SCREEN_UV).rgb;
}