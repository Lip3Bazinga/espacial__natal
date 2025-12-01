shader_type spatial;

uniform sampler2D surface_texture;
uniform float base_emission : hint_range(0, 20) = 8.0;
uniform float hotspot_intensity : hint_range(0, 50) = 25.0;

// Efeito de pulso para manchas solares
uniform float pulse_frequency : hint_range(0, 10) = 2.0;

void fragment() {
    // Textura da superfície solar
    vec4 surface = texture(surface_texture, UV);
    
    // Pulsação para efeito dinâmico
    float pulse = (sin(TIME * pulse_frequency) + 1.0) * 0.5;
    
    // Áreas regulares + hotspots mais brilhantes
    float regular_emission = base_emission * surface.r;
    float hotspot_emission = hotspot_intensity * pulse;
    
    ALBEDO = surface.rgb * 0.2;
    EMISSION = surface.rgb * (regular_emission + hotspot_emission);
    
    METALLIC = 0.1;
    ROUGHNESS = 0.7;
}