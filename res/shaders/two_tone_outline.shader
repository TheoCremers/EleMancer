shader_type canvas_item;

uniform float outline_width : hint_range(0.0, 30.0);
uniform vec4 color1 : hint_color;
uniform vec4 color2 : hint_color;

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

void fragment() {
	vec2 pos = UV;
	vec4 outline_color = mix(color1, color2, clamp(noise(pos*10.0 + TIME*2.0)*3.0+.5, 0.0, 1.0));
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
	//COLOR = outline_color;
}