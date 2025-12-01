extends Node3D

@export var terra: Node3D
@export var velocidade_angular_phi: float = 60.0
@export var velocidade_angular_theta: float = 60.0
@export var raio_orbita_inicial: float = 20.0

var R: float
var phi: float = 0.0 # Longitude (gira ao redor do Y)
var theta: float = 0.0 # Latitude (ângulo polar, 0=Polo Norte, 180=Polo Sul)

func _ready():
	R = raio_orbita_inicial

func _process(delta: float) -> void:
	if not terra:
		return

	var input_theta = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var input_phi = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# 1. Atualiza e Normaliza PHI (Longitude)
	phi += input_phi * velocidade_angular_phi * delta
	# Garante que PHI permaneça entre 0 e 360 graus para evitar números gigantes
	# e problemas de precisão, mantendo a rotação infinita.
	phi = fmod(phi, 360.0) 
	if phi < 0:
		phi += 360.0
	
	# 2. Atualiza e LIMITA THETA (Latitude)
	theta += -input_theta * velocidade_angular_theta * delta
	
	# O problema de inversão ocorre APENAS quando theta passa por 0 (Polo Norte) 
	# ou 180 (Polo Sul). O clamp é a solução mais simples para evitar essa inversão.
	# Manter o limite de 1.0 a 179.0 impede a inversão de controle.
	if(theta == 0 or theta == 180):
		velocidade_angular_theta *= -1
		phi += 180
	
	var centro = terra.global_position
	
	var phi_rad = deg_to_rad(phi)
	var theta_rad = deg_to_rad(theta)
	
	# Conversão para Cartesianas:
	# x = R * sin(theta) * cos(phi)
	# z = R * sin(theta) * sin(phi)
	# y = R * cos(theta)
	var x = R * sin(theta_rad) * cos(phi_rad)
	var z = R * sin(theta_rad) * sin(phi_rad)
	var y = R * cos(theta_rad)
	
	global_position.x = centro.x + x
	global_position.y = centro.y + y
	global_position.z = centro.z + z
	
	var direcao_para_fora = (global_position - centro).normalized()
	
	var proxima_posicao_simulada = centro + Vector3(
		R * sin(theta_rad) * cos(deg_to_rad(phi + 1)),
		y,
		R * sin(theta_rad) * sin(deg_to_rad(phi + 1))
	)
	
	look_at(proxima_posicao_simulada, direcao_para_fora)
