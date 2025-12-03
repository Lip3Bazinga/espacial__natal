extends MeshInstance3D
		
var rotation_speed_deg: float = 10 

func _process(delta: float) -> void:
	#girar ao redor do seu eixo
	rotation_degrees.y += rotation_speed_deg * delta
