extends CharacterBody3D

@export var terra: Node3D
@export var country_mask_tex: Texture2D
@export var velocidade_treno: float = 0.1
@export var velocidade_treno_min: float = 0.05
@export var velocidade_treno_max: float = 0.2
@export var velocidade_curva: float = 0.03
@export var ang_declinacao: float = 25.0

var vetor_x: Vector3
var vetor_y: Vector3
var suavizador_curva := 0.0
var suave := 0.0
var treno: Node3D
var inclinacao_alvo := 0.0
var inclinacao_atual := 0.0
var camera: Camera3D

func _ready():
	vetor_x = (global_position - terra.global_position).normalized()

	if(vetor_x.dot(Vector3(0, 0, 1)) != 1):
		vetor_y = vetor_x.cross(Vector3(0, 0, 1)).normalized()
	else:
		vetor_y = vetor_x.cross(Vector3(0, 1, 0)).normalized()

	treno = get_node("treno")
	camera = get_node("CameraPlayer")
	
func _input(event: InputEvent) -> void:
	# ====== TECLA SPACE ======
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE:
			identificar_pais_abaixo()

	#tecla pressionada
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_W:
			velocidade_treno = lerp(velocidade_treno, velocidade_treno_max, 0.1)

		if event.keycode == KEY_S:
			velocidade_treno = lerp(velocidade_treno, velocidade_treno_min, 0.1)

		if event.keycode == KEY_A:
			suavizador_curva = 1.0
			inclinacao_alvo = -deg_to_rad(ang_declinacao)

		if event.keycode == KEY_D:
			suavizador_curva = -1.0
			inclinacao_alvo = deg_to_rad(ang_declinacao)
	
	#tecla liberada
	if event is InputEventKey and event.is_released():
		if event.keycode == KEY_W or event.keycode == KEY_S:
			velocidade_treno = 0.1

		if event.keycode == KEY_A or event.keycode == KEY_D:
			suavizador_curva = 0.0
			inclinacao_alvo = 0.0
	
	#scroll do mouse
	if event is InputEventMouseButton:
		var zoom_dir = (camera.global_position - treno.global_position)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			if(zoom_dir.length() > 2.0):
				camera.global_position = camera.global_position - 1.1*zoom_dir.normalized()

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			if(zoom_dir.length() < 10.0):
				camera.global_position = camera.global_position + 1.1*zoom_dir.normalized()

# =====================================================================
# FUNÇÃO QUE DETECTA O PAÍS ABAIXO DO TRENÓ
# =====================================================================
func identificar_pais_abaixo():
	# Vetor do centro da Terra para o trenó → ponto diretamente abaixo
	var p = (global_position - terra.global_position).normalized()

	# Converte direção em UV esférico
	var u = atan2(p.z, p.x) / (2.0 * PI) + 0.5
	var v = p.y * 0.5 + 0.5

	# Lê a cor no mapa
	if not country_mask_tex:
		print("ERRO: country_mask_tex não definido!")
		return

	var img = country_mask_tex.get_image()
	var cor = img.get_pixel(u, v)

	# Prints pedidos
	print("=========================")
	print("POSIÇÃO NORMALIZADA: ", p)
	print("UV: ", Vector2(u, v))
	print("COR NO MAPA: ", cor)
	print("=========================")

func _process(delta: float) -> void:
	if not terra:
		return

	# ORBITA
	global_position -= terra.global_position
	global_position = global_position.rotated(vetor_y, deg_to_rad(velocidade_treno))
	global_position += terra.global_position

	vetor_x = vetor_x.rotated(vetor_y, deg_to_rad(velocidade_treno)).normalized()

	# CURVAS
	suave = lerp(suave, suavizador_curva, 0.1)
	var ang_curva = velocidade_curva * suave
	vetor_y = vetor_y.rotated(vetor_x, ang_curva).normalized()

	look_at(terra.global_position, vetor_y)

	# INCLINAÇÃO
	inclinacao_atual = lerp(inclinacao_atual, inclinacao_alvo, 5.0 * delta)
	treno.rotation.x = inclinacao_atual + deg_to_rad(-90)
	treno.rotation.y = -abs(inclinacao_atual) + deg_to_rad(90)


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("BUNDA")
