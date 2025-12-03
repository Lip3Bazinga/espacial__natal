extends MeshInstance3D

@export var terra: Node3D
var phi: float = 0
var R: float = 500

func _process(delta: float) -> void:
	if terra:
		phi -= 0.36*delta
		var centro = terra.global_position
		global_position.x = centro.x + R * cos(deg_to_rad(phi))
		global_position.z = centro.z + R * sin(deg_to_rad(phi))
		global_position.y = centro.y
