extends Node3D

@export var terra: Node3D
@export var velocidade_angular_phi: float = 60.0   # Velocidade Esquerda/Direita
@export var velocidade_angular_theta: float = 60.0 # Velocidade Cima/Baixo
@export var raio_orbita_inicial: float = 20.0

var R: float
var phi: float = 0.0 
var theta: float = 90.0 # Começamos no meio (90) para evitar o bug do polo (0)

# Variável para controlar se estamos subindo ou descendo
var direcao_theta: float = 1.0 

func _ready():
	R = raio_orbita_inicial
	if not terra:
		terra = get_node("../Terra/TerraSolida") # Ajuste o caminho se necessário

func _process(delta: float) -> void:
	if not terra:
		return

	# Pega os inputs
	var input_theta = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var input_phi = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# --- 1. Atualiza PHI (Longitude/Horizontal) ---
	phi += input_phi * velocidade_angular_phi * delta
	phi = fmod(phi, 360.0) 
	if phi < 0: phi += 360.0
	
	# --- 2. Atualiza THETA (Latitude/Vertical) ---
	# Usamos a 'direcao_theta' para inverter o controle quando bater nos polos
	theta += -input_theta * velocidade_angular_theta * delta * direcao_theta
	
	# --- 3. PROTEÇÃO DOS POLOS (A Correção Real) ---
	# Usamos 0.1 e 179.9 porque 'float' nunca é exatamente 0
	if theta <= 0.1:
		theta = 0.1         # Empurra de volta
		direcao_theta *= -1 # Inverte o controle
		phi += 180          # Gira o mundo (efeito de passar pelo polo)
		
	elif theta >= 179.9:
		theta = 179.9
		direcao_theta *= -1
		phi += 180

	# --- 4. CÁLCULO DE POSIÇÃO ---
	var centro = terra.global_position
	var phi_rad = deg_to_rad(phi)
	var theta_rad = deg_to_rad(theta)
	
	# Matemática esférica
	var x = R * sin(theta_rad) * cos(phi_rad)
	var z = R * sin(theta_rad) * sin(phi_rad)
	var y = R * cos(theta_rad)
	
	var nova_posicao = centro + Vector3(x, y, z)
	
	# Aplica a posição
	global_position = nova_posicao
	
	# --- 5. OLHAR PARA FRENTE (Anti-Crash) ---
	var direcao_para_fora = (global_position - centro).normalized()
	
	# Simulamos um ponto um pouco à frente (1 grau no futuro)
	var next_phi_rad = deg_to_rad(phi + 1.0) 
	
	var next_x = R * sin(theta_rad) * cos(next_phi_rad)
	var next_z = R * sin(theta_rad) * sin(next_phi_rad)
	var next_y = y # Mantemos a altura Y
	
	var ponto_futuro = centro + Vector3(next_x, next_y, next_z)
	
	# Só olha se o ponto futuro for diferente do atual (maior que 1 milímetro)
	if global_position.distance_to(ponto_futuro) > 0.001:
		look_at(ponto_futuro, direcao_para_fora)
