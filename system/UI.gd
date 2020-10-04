extends CanvasLayer

func config_task_box(task):
	$Vertical/Task.visible = true
	$Vertical/Task/Margin/Vertical/Value.text = task["label"]

func clear_task_box():
	$Vertical/Task.visible = false

func set_oxygen_value(val):
	$Vertical/Status/Margin/Vertical/Oxygen/Progress.value = val
