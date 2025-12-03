extends Node3D

var rotation_speed_deg: float = 0.36
var phi: float = 0
var R: float = 2000
	
func _process(delta: float) -> void:
	#voltar inclinacao 0
	rotation_degrees.x -= 23
	#girar ao redor do seu eixo
	rotation_degrees.y += rotation_speed_deg * delta
	#voltar inclinacao 0
	rotation_degrees.x += 23
	
	#orbita ao redor do sol
	phi += 0.0	
	position.x = R*cos(deg_to_rad(phi))
	position.z = R*sin(deg_to_rad(phi))
	
	if(phi >= 360):
		phi = 0
