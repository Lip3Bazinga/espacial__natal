extends WorldEnvironment

func _ready():
	setup_sun_glow_environment()

func setup_sun_glow_environment():
	if not environment:
		environment = Environment.new()
	
	# Configuração do GLOW (Bloom)
	environment.glow_enabled = true
	environment.glow_normalized = true
	environment.glow_intensity = 1.2
	environment.glow_strength = 2.0
	environment.glow_bloom = 0.8
	environment.glow_blend_mode = Environment.GLOW_BLEND_MODE_SOFTLIGHT
	environment.glow_hdr_threshold = 1.5
	environment.glow_hdr_scale = 2.0
	
	# Camadas de glow
	environment.glow_levels = {
		"1": true,
		"2": true,
		"3": true,
		"4": true,
		"5": true,
		"6": true,
		"7": true
	}
