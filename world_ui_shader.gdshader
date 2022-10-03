shader_type canvas_item;

vec3 RGBtoHSV(vec3 input_color){
	vec3 c = vec3(input_color);
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 HSVtoRGB(vec3 input_color){
	vec3 c = vec3(input_color);
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float vignetting(vec2 uv){
    uv *=  1.0 - uv.yx;   //vec2(1.0)- uv.yx; -> 1.-u.yx; Thanks FabriceNeyret   
    float vig = uv.x*uv.y * 15.0; // multiply with sth for intensity
    return pow(vig, 0.25); // change pow for modifying the extend of the  vignette
}

void fragment() {
	vec3 current_color = textureLod(SCREEN_TEXTURE, SCREEN_UV,0.0).xyz;
	
	{
		//Desaturate and shift hue
		vec3 HSVColor = RGBtoHSV(current_color);
		HSVColor.r = max(HSVColor.r - 0.05, 0.0);
		HSVColor.g = max(HSVColor.g - 0.4, 0.0);
		current_color = HSVtoRGB(HSVColor);
	}
	
//	{
//		//Add vignetting effect
//		float vignette_effect = clamp(vignetting(UV)+0.1,0.0,1.0);
//		float inverse_vignette_effect = 1.0-vignette_effect;
//		vec3 HSVColor = RGBtoHSV(current_color);
//		HSVColor.b = HSVColor.b*vignette_effect;
//		HSVColor.g = HSVColor.g+inverse_vignette_effect*0.5;
//		current_color = HSVtoRGB(HSVColor);
//	}

	COLOR = vec4(current_color, 1.0);
}