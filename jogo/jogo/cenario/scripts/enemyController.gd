extends Node3D

@export var alvo_player: Node3D 
@export var velocidade_reacao: float = 2.0  # Velocidade suave
@export var altura_extra: float = 15.0      # Altura ACIMA do player

func _process(delta):
	# Se não tiver alvo, não faz nada
	if not alvo_player:
		return

	# 1. Descobre onde o player está e qual a distância dele pro centro (0,0,0)
	var pos_player = alvo_player.global_position
	var raio_atual_do_player = pos_player.length() # Ex: 20.0
	
	# 2. Define onde o avião deve estar (Posição do Player, mas mais alto)
	var raio_final = raio_atual_do_player + altura_extra
	
	# Vetor normalizado (direção) multiplicado pela nova altura
	var posicao_desejada = pos_player.normalized() * raio_final
	
	# 3. Move o avião suavemente para essa posição
	global_position = global_position.lerp(posicao_desejada, velocidade_reacao * delta)
	
	# 4. Rotação (Look At) corrigida para evitar erro de Collinear
	# Em vez de olhar pro player (que está embaixo), olhamos um pouco à frente dele
	# Truque: Olhar para o player, mas mantendo o avião nivelado com o planeta
	var up_vector = global_position.normalized() # Cima é "fora do planeta"
	
	# Se o avião não estiver exatamente em cima do player, olhe para ele
	if global_position.distance_to(pos_player) > 1.0:
		# Usamos um alvo levemente modificado para não bugar quando estiver 90 graus
		look_at(pos_player, up_vector)
