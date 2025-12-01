extends DirectionalLight3D

func _ready() -> void:
	rotation_degrees.y = -90

func _process(delta: float) -> void:
	rotation_degrees.y -= 0.1
