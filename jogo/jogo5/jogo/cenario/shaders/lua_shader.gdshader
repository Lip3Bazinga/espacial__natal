shader_type spatial;
render_mode cull_back, depth_draw_opaque;

/////////////////////////////////////////////////
// UNIFORMS (texturas e controle)
/////////////////////////////////////////////////
uniform sampler2D color_tex;    // mapa de cor (albedo)

/////////////////////////////////////////////////
// FRAGMENT: cor direta do mapa de cor
/////////////////////////////////////////////////
void fragment() {
    ALBEDO = texture(color_tex, UV).rgb;
    ROUGHNESS = 0.8;
    METALLIC = 0.0;
}