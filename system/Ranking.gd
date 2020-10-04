extends HBoxContainer

export var visible_count : int = 0

func _process(_delta):
	for i in range(0, 5):
		get_child(i).visible = i < visible_count
