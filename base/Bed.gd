extends StaticBody

func _on_ActionArea_used_once():
	var world = get_node("/root/World")
	if fmod(world.time, world.day_time*2) > world.day_time:
		world.time += world.day_time
