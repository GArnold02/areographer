extends RigidBody


func _on_ActionArea_used_once():
	Manager.task_success()
	queue_free()
