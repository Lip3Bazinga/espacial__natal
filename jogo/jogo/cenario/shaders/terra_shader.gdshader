shader_type spatial;
render_mode cull_back, depth_draw_opaque;

/////////////////////////////////////////////////
// UNIFORMS (texturas e controle)
/////////////////////////////////////////////////
uniform sampler2D height_tex;   // heightmap (B/W)
uniform sampler2D color_tex;    // mapa de cor (albedo)
uniform float height_scale = 0.02; // intensidade do relevo
uniform bool invert_height = false;

/////////////////////////////////////////////////
// VERTEX: displacement pelo heightmap
/////////////////////////////////////////////////
void vertex() {
    // lê altura (assume grayscale no canal R)
    float h = texture(height_tex, UV).r;
    if (invert_height) {
        h = 1.0 - h;
    }

    // desloca o vértice ao longo da normal
    VERTEX += normalize(NORMAL) * (h * height_scale);
}

/////////////////////////////////////////////////
// FRAGMENT: cor direta do mapa de cor
/////////////////////////////////////////////////
void fragment() {
    ALBEDO = texture(color_tex, UV).rgb;
    ROUGHNESS = 0.8;
    METALLIC = 0.0;
}
