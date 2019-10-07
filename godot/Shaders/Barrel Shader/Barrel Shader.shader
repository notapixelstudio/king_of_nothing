// Modified version of fisheyeeffect by henriquelalves
// Original based on http://www.geeks3d.com/20140213/glsl-shader-library-fish-eye-and-dome-and-barrel-distortion-post-processing-filters/2/
// I created this version because the henrique's did not work in my version of Godot 3.0.5. I haven't tested it in more current versions
// Reddit user krdluzni answered a question I had regarding basic shader functions, so thanks krdluzni!
// This version of the shader works by reading and modifying a portion of the screen, rather than just modifying a texture
// This makes it useful for things like magnifying glasses, black holes or gravity wells, telescopes, etc


shader_type canvas_item;

uniform float PI = 3.1415926535;
uniform float BarrelPower;
vec2 distort(vec2 p) {
	
	if(p.x > 0.0){
		float angle = p.y / p.x;
		float theta = atan(angle);
		float radius = length(p);
		radius = pow(radius, BarrelPower);
		
		p.x = radius * cos(theta);
		p.y = radius * sin(theta);
	} else {
		float angle = p.y / p.x;
		float theta = atan(angle);
		float radius = length(p);
		radius = pow(radius, BarrelPower);
		
		p.y = radius * sin(-theta);
		p.x = radius * cos(theta);
		p.x = - p.x;
	}
	
	
	return 0.5 * (p + vec2(1.0,1.0));
}

void fragment(){
vec2 xy = (2.0 * SCREEN_UV);

xy.x = xy.x-1.0;
xy.y = xy.y-1.0;

float d = length(xy);
if(d < 1.5){
	xy = distort(xy);
}
else{
	xy = SCREEN_UV;
}
COLOR = texture(SCREEN_TEXTURE, xy);
}