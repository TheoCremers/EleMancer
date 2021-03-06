shader_type canvas_item;

uniform float transition_time : hint_range(-1.0, 1.0);
uniform float transition_border : hint_range(0.0, 1.0); 
uniform vec4 color : hint_color;

// return a random vector in range [-1, 1] for both x and y
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
	vec4 image = texture(TEXTURE, UV);
	vec4 none = vec4(0.0, 0.0, 0.0, 0.0);
	vec4 transition_color = vec4(color.rgb, image.a);
	vec4 final_color;
	float noise = noise(pos*10.0 + TIME*3.0) * (1.0 - transition_border);
	float border_time1 = transition_time - transition_border * 0.5;
	float border_time2 = transition_time - transition_border;
	
	if (transition_time < noise) {
		final_color = none;
	} else if (border_time1 < noise) {
		final_color = mix(transition_color, none, (noise - border_time1) / (transition_time - border_time1));
	} else if (border_time2 < noise) {
		final_color = mix(image, transition_color, (noise - border_time2) / (border_time1 - border_time2));
	} else {
		final_color = image;
	}
	
	COLOR = final_color;
}