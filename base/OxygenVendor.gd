extends StaticBody

export var replenish_rate : float

func _on_ActionArea_used(delta):
	get_node("/root/World/Astronaut").oxygen += replenish_rate * delta
