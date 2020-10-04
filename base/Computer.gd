extends StaticBody
export(Array, String) var tasks

func _on_ActionArea_used_once():
	var task = tasks[randi() % tasks.size()]
	Manager.assign_task(task)
