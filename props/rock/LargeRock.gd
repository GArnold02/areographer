extends Spatial

export var inspect_rate : float
var value : float = 0
var is_used = false

func _process(delta):
	if !$ActionArea/Shape.disabled:
		$ActionArea.set_progress(value)
	
	if !is_used:
		value -= inspect_rate /2 * delta
	else:
		if value > 99.5:
			$ActionArea.disable()
			Manager.task_success()
	
	value = clamp(value, 0, 100)
	is_used = false

func _on_ActionArea_used(delta):
	is_used = true
	value += inspect_rate * delta
