extends Node3D  # (Ou Node, dependendo do que você usou)

# --- 1. VARIÁVEIS (Coloque logo no começo do arquivo) ---
# Aqui você conecta o Label que você criou. 
# DICA: Apague o "$CanvasLayer/TimerLabel" abaixo e arraste o seu nó Label
# da árvore de cenas para cá segurando a tecla CTRL. O Godot preenche o caminho certo.
@onready var label_tempo = $ScoreCounter

var tempo_decorrido = 0.0
var jogo_ativo = true

func _ready():
	# Se tiver algum código de inicialização, ele fica aqui
	pass

# --- 2. LOOP DO JOGO (Coloque ou adicione ao _process existente) ---
func _process(delta):
	# Se você já tem um _process, apenas adicione o conteúdo do 'if' dentro dele
	if jogo_ativo:
		tempo_decorrido += delta
		atualizar_interface()

# --- 3. FUNÇÕES NOVAS (Coloque no final do arquivo) ---

func atualizar_interface():
	var minutos = int(tempo_decorrido / 60)
	var segundos = int(tempo_decorrido) % 60
	label_tempo.text = "%02d:%02d" % [minutos, segundos]

func game_over():
	jogo_ativo = false
	# Aqui você pode chamar sua tela de Game Over também
	print("O jogo acabou! Tempo: ", label_tempo.text)
