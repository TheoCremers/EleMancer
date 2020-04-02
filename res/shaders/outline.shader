shader_type canvas_item;

uniform float outline_width : hint_range(0.0, 30.0);
uniform vec4 outline_color : hint_color;

//void fragment()
//{
//	float size = width * 1.0 / float(textureSize(TEXTURE, 0).x);
//	vec4 sprite_color = texture(TEXTURE, UV);
//	float alpha = -4.0 * sprite_color.a;
//	alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
//	alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
//	alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
//	alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;
//
//	vec4 final_color = mix(sprite_color, outline_color, clamp(alpha, 0.0, 1.0));
//	COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
//}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;
	float a;
	float maxa = col.a;
	float mina = col.a;

	a = texture(TEXTURE, UV + vec2(0.0, -outline_width) * ps).a;
	maxa = max(a, maxa);
	a = texture(TEXTURE, UV + vec2(0.0, outline_width) * ps).a;
	maxa = max(a, maxa);
	a = texture(TEXTURE, UV + vec2(-outline_width, 0.0) * ps).a;
	maxa = max(a, maxa);
	a = texture(TEXTURE, UV + vec2(outline_width, 0.0) * ps).a;
	maxa = max(a, maxa);
	a = texture(TEXTURE, UV + vec2(outline_width*0.7, -outline_width*0.7) * ps).a;
	maxa = max(a, maxa);
	a = texture(TEXTURE, UV + vec2(outline_width*0.7, outline_width*0.7) * ps).a;
	maxa = max(a, maxa);
	a = texture(TEXTURE, UV + vec2(-outline_width*0.7, outline_width*0.7) * ps).a;
	maxa = max(a, maxa);
	a = texture(TEXTURE, UV + vec2(-outline_width*0.7, -outline_width*0.7) * ps).a;
	maxa = max(a, maxa);
	
	COLOR = mix(col, outline_color, maxa - mina);
}