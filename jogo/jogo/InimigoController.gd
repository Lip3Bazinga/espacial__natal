extends CharacterBody3D

@export var terra: Node3D # DEVE ser o Node3D pai do planeta
@export var velocidade_inimigo: float = 0.08 # Ajuste a velocidade de órbita (graus/frame)
@export var velocidade_curva_inimigo: float = 0.02 # Ajuste a velocidade de curva
@export var raio_orbita: float # Será definido pelo Spawner
@export var direcao_orbita: int = 1 # 1 (horário) ou -1 (anti-horário)

var vetor_x: Vector3
var vetor_y: Vector3
var suavizador_curva := 0.0 # Para movimento lateral aleatório

func _ready():
	# Inicializa o gerador de números aleatórios
	randomize()

	# Define uma posição inicial aleatória
	# Primeiro, um vetor aleatório na esfera
	var pos_aleatoria = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	
	# Define a posição inicial na órbita, usando a posição global da Terra como centro
	global_position = terra.global_position + pos_aleatoria * raio_orbita
	
	# Define a direção de órbita e curva aleatoriamente
	direcao_orbita = [-1, 1].pick_random()
	suavizador_curva = randf_range(-1.0, 1.0)
	
	# Inicializa os vetores de orientação
	vetor_x = (global_position - terra.global_position).normalized()
	
	# Garante que vetor_y seja perpendicular a vetor_x
	if vetor_x.dot(Vector3.UP) != 1.0 and vetor_x.dot(Vector3.UP) != -1.0:
		vetor_y = vetor_x.cross(Vector3.UP).normalized()
	else:
		# Alternativa caso vetor_x esteja alinhado com o eixo Y
		vetor_y = vetor_x.cross(Vector3.FORWARD).normalized()
	
func _process(delta: float) -> void:
	if not is_instance_valid(terra):
		return

	# ── Movimento para frente (orbital)
	var angulo_orbita = deg_to_rad(velocidade_inimigo) * direcao_orbita

	# 1. Move o CharacterBody3D para o centro (Terra)
	global_position -= terra.global_position
	
	# 2. Rotaciona em torno do centro
	global_position = global_position.rotated(vetor_y, angulo_orbita)
	
	# 3. Move o CharacterBody3D de volta à posição correta
	global_position += terra.global_position

	# Atualiza vetor_x para refletir a nova direção de movimento
	vetor_x = vetor_x.rotated(vetor_y, angulo_orbita).normalized()

	# ── "Curvas" laterais aleatórias
	var ang_curva = velocidade_curva_inimigo * suavizador_curva * delta * 60.0
	vetor_y = vetor_y.rotated(vetor_x, ang_curva).normalized()

	# ── Orientação CORRIGIDA (Apenas modifica a rotação, mantendo a posição)
	var vetor_frente = -vetor_x.cross(vetor_y) * direcao_orbita
	
	# Cria a nova rotação (Basis)
	var nova_basis = Basis.looking_at(vetor_frente, vetor_x)
	
	# Aplica a rotação à Transform3D atual, preservando a posição (origin)
	transform.basis = nova_basis
