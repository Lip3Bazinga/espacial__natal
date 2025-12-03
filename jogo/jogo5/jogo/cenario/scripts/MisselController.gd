extends CharacterBody3D

@export var alvo_player: Node3D
@export var velocidade_movimento: float = 20.0 # Velocidade real do míssil
@export var velocidade_curva: float = 3.0       # Quão rápido ele vira (Curvas mais lentas/largas = valor menor)

# Vetor de movimento atual do míssil
var direcao_atual: Vector3 = Vector3.FORWARD 

func _physics_process(delta):
	# Usamos _physics_process para movimento de CharacterBody3D
	
	if not alvo_player:
		return

	# 1. Calcula a direção para o alvo
	var direcao_para_alvo = (alvo_player.global_position - global_position).normalized()

	# 2. Interpolação da Direção (O coração das curvas largas)
	# Mistura a direção atual do míssil com a direção desejada (para o alvo).
	# Um valor pequeno para 'velocidade_curva * delta' resulta em curvas mais abertas.
	direcao_atual = direcao_atual.lerp(direcao_para_alvo, velocidade_curva * delta).normalized()

	# 3. Rotação do Míssil (Olhar na direção do movimento)
	# O míssil rotaciona suavemente porque sua 'direcao_atual' está mudando suavemente.
	if direcao_atual.length_squared() > 0.0001:
		# A função 'look_at' pode ser usada aqui, pois a 'direcao_atual'
		# já está sendo suavizada pelo 'lerp' no passo 2.
		look_at(global_position + direcao_atual, Vector3.UP)
	
	# 4. Aplica o movimento
	# O míssil sempre avança em sua 'direcao_atual'
	velocity = direcao_atual * velocidade_movimento
	
	move_and_slide()
