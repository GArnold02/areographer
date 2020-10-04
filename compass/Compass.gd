extends Spatial

export var target : NodePath

func _physics_process(_delta):
	var target_node = get_node_or_null(target)
	
	if target_node != null:
		look_at(target_node.global_transform.origin, Vector3.UP)
		rotation_degrees.x = 0
		rotation_degrees.z = 0
		visible = true
	else:
		visible = false
