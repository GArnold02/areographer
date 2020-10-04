extends Spatial

export var astronaut_path : NodePath
export var smoothing : float
export var sensitivity : float

var mouse_delta : Vector2
var height_rot : float

func _physics_process(delta):
	var astronaut = get_node(astronaut_path)
	translation = lerp(translation, astronaut.translation, smoothing)
	
	_look(delta)

func _look(delta):
	rotate_y(deg2rad(-mouse_delta.x) * sensitivity * delta)
	height_rot += -mouse_delta.y * sensitivity * delta
	height_rot = clamp(height_rot, -70, 10)
	$Height.rotation_degrees.x = height_rot
	
	mouse_delta = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
