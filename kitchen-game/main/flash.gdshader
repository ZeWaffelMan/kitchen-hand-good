shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0);
uniform float alpha = 0.0;
uniform bool active = false;

void fragment() {
	if(active){
		vec4 color = texture(TEXTURE, UV);
		color.rgb = mix(color.rgb, flash_color.rbg, alpha);
		COLOR = color;
	}
}
