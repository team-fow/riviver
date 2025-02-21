shader_type canvas_item;

uniform sampler2D pattern : repeat_enable;


void fragment() {
	COLOR.rgb = texture(pattern, SCREEN_UV + TIME / 60.0).rgb;
}