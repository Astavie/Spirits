shader_type canvas_item;

uniform vec4 color_hair : hint_color;
uniform vec4 color_skin : hint_color;
uniform vec4 color_body : hint_color;

uniform vec4 replacement_hair : hint_color;
uniform vec4 replacement_skin : hint_color;
uniform vec4 replacement_body : hint_color;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    vec3 col = original_color.rgb;
	
	// Hair
    vec3 diff = col - color_hair.rgb;
    float m = max(max(abs(diff.r), abs(diff.g)), abs(diff.b));
	
    float brightness = length(col);
    col = mix(col, replacement_hair.rgb * brightness, step(m, 0));
	
	// Skin
	diff = col - color_skin.rgb;
	m = max(max(abs(diff.r), abs(diff.g)), abs(diff.b));
	
	brightness = length(col);
	col = mix(col, replacement_skin.rgb * brightness, step(m, 0));
	
	// Body
	diff = col - color_body.rgb;
	m = max(max(abs(diff.r), abs(diff.g)), abs(diff.b));
	
	brightness = length(col);
	col = mix(col, replacement_body.rgb * brightness, step(m, 0));
	
    COLOR = vec4(col.rgb, original_color.a);
}
