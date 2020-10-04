extends StaticBody

export var astronaut : NodePath
export var snap : int

func _physics_process(delta):
	var astronaut_pos = get_node(astronaut).translation
	translation.x = (int(astronaut_pos.x) / snap) * snap
	translation.z = (int(astronaut_pos.z) / snap) * snap
	pass
