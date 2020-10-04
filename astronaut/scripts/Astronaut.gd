extends KinematicBody

export var walk_speed : float
export var run_speed : float
export var turn_speed : float
export var friction : float
export var gravity : float
export var jump_force : float
export var cam_origin_path : NodePath
export var max_oxygen : float

var velocity : Vector3
var oxygen : float
var is_freezed = false

func freeze():
	is_freezed = true

func _ready():
	oxygen = max_oxygen
	
	$astronaut/AnimationPlayer.playback_speed = walk_speed * 1.25
	$astronaut/AnimationPlayer.get_animation("Idle").loop = true
	$astronaut/AnimationPlayer.get_animation("Walk").loop = true
	$astronaut/AnimationPlayer.get_animation("Jump").loop = false
	$astronaut/AnimationPlayer.play("Idle")

func _physics_process(delta):
	if !is_freezed:
		_deplete_resources(delta)
		_move(delta)
		_jump()
		_physics(delta)
		_animate()
		oxygen = clamp(oxygen, 0, max_oxygen)
	else:
		$astronaut/AnimationPlayer.stop()

func _deplete_resources(delta):
	oxygen -= delta
	get_node("/root/UI").set_oxygen_value(int(oxygen / max_oxygen * 100))
	if oxygen <= 0.0:
		Manager.end(true, get_node("..").elapsed_days())
		$Breath.stop()

func _move(delta):
	var desired_direction : Vector3
	
	if Input.is_action_pressed("walk_forward"):
		desired_direction += Vector3(0,0, -1) * delta
	if Input.is_action_pressed("walk_backward"):
		desired_direction += Vector3(0,0, 1) * delta
	if Input.is_action_pressed("walk_left"):
		desired_direction += Vector3(-1,0, 0) * delta
	if Input.is_action_pressed("walk_right"):
		desired_direction += Vector3(1,0, 0) * delta
		
	if desired_direction.length() > 0:
		var cam_origin = get_node(cam_origin_path)
		var cam_forward = cam_origin.global_transform.basis.z
		var cam_quat = Quat(Basis(Vector3.UP.cross(cam_forward).normalized(), Vector3.UP, cam_forward))
		
		var rot_target = global_transform.looking_at(translation + cam_quat * desired_direction,Vector3.UP)
		var rot_final = Quat(global_transform.basis).slerp(Quat(rot_target.basis), turn_speed)
		global_transform = Transform(Basis(rot_final), global_transform.origin)
		velocity -= global_transform.basis.z * walk_speed

func _jump():
	if Input.is_action_pressed("jump") && $GroundRay.is_colliding():
		velocity.y = jump_force

func _physics(delta):
	velocity -= Vector3.UP * gravity * delta
	
	velocity.x = lerp(velocity.x,0,friction)
	velocity.z = lerp(velocity.z,0,friction)
	
	if Input.is_action_pressed("jump"):
		velocity = move_and_slide(velocity, Vector3.UP)
	else:
		velocity = move_and_slide_with_snap(velocity, Vector3(0,-0.1,0), Vector3.UP)

func _animate():
	if $GroundRay.is_colliding():
		var vec = Vector2(velocity.x, velocity.z)
		if vec.length() > 0.5:
			$astronaut/AnimationPlayer.play("Walk")
		else:
			$astronaut/AnimationPlayer.play("Idle")
	else:
		$astronaut/AnimationPlayer.play("Jump")
