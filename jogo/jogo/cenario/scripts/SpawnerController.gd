extends Node3D

@export var terra: Node3D
@export var inimigo_scene: PackedScene
@export var raio_orbita_inimigo: float = 64.0
@export var intervalo_spawn: float = 0.1
@export var max_inimigos: int = 1000

var tempo_passado: float = 0.0

func _ready():
	# Inicializa o gerador de números aleatórios
	randomize()

	# 1. Gera os 30 inimigos iniciais
	for i in range(30):
		spawn_inimigo()

func _process(delta: float) -> void:
	if not inimigo_scene or not terra:
		return

	tempo_passado += delta

	if tempo_passado >= intervalo_spawn:
		tempo_passado = 0.0
		if get_child_count() < max_inimigos:
			spawn_inimigo()

func spawn_inimigo():
	var novo_inimigo = inimigo_scene.instantiate() as CharacterBody3D
	
	# Configurações do Inimigo:
	# O script Inimigo só precisa da posição global do nó Terra.
	novo_inimigo.terra = terra
	novo_inimigo.raio_orbita = raio_orbita_inimigo
	
	# Define a posição inicial aleatória em relação à POSIÇÃO GLOBAL DA TERRA
	var vetor_direcao = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	
	# Usa terra.global_position, que é a posição do seu Node3D pai
	novo_inimigo.global_position = terra.global_position + vetor_direcao * raio_orbita_inimigo
	
	add_child(novo_inimigo)
