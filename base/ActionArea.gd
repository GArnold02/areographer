extends Area
signal used(delta)
signal used_once

export var hint : String
export var start_disabled : bool
export var use_progress : bool
export var progress_size : Vector2

var action_hint = null
var show_hint = false

func enable():
	$Shape.disabled = false

func disable():
	$Shape.disabled = true
	if show_hint:
		action_hint.get_node("Margin/Vertical/Label").text = ""
		action_hint.get_node("Margin/Vertical/Progress").hide()
		action_hint.hide()
		show_hint = false

func set_progress(value):
	action_hint.get_node("Margin/Vertical/Progress").value = value

func _ready():
	action_hint = get_node("/root/UI/ActionHint")
	$Shape.disabled = start_disabled

func _process(delta):
	if show_hint:
		var cam = get_viewport().get_camera()
		action_hint.rect_position = cam.unproject_position(global_transform.origin)
		
		if Input.is_action_just_pressed("action"):
			emit_signal("used_once")
		if Input.is_action_pressed("action"):
			emit_signal("used", delta)

func _on_ActionArea_body_entered(body):
	if body.is_in_group("astronaut"):
		action_hint.show()
		action_hint.rect_size = Vector2.ZERO
		action_hint.get_node("Margin/Vertical/Label").text = "[E] %s" % hint
		
		if use_progress:
			action_hint.get_node("Margin/Vertical/Progress").show()
			action_hint.get_node("Margin/Vertical/Progress").rect_min_size = progress_size
			
		show_hint = true


func _on_ActionArea_body_exited(body):
	if body.is_in_group("astronaut"):
		action_hint.get_node("Margin/Vertical/Label").text = ""
		action_hint.get_node("Margin/Vertical/Progress").hide()
		action_hint.hide()
		show_hint = false
