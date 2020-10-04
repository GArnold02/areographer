extends Node

var world_scene = preload("res://world/World.tscn")
var ui_scene = preload("res://system/UI.tscn")
var crate_scene = preload("res://props/crate/Crate.tscn")

var has_task : bool = false
var completed_tasks : int = 0
var failed_tasks : int = 0
var task_deadline : float = 0

func assign_task(task):
	if has_task:
		return
	clear_task()
	
	var file = File.new()
	file.open("res://tasks/%s.json" % task, File.READ)
	var json = JSON.parse(file.get_as_text()).result
	task_deadline = json["goal"]["deadline"]
	
	var ui = get_tree().root.get_node("UI")
	ui.config_task_box(json)
	
	var astronaut = get_tree().root.get_node("World/Astronaut")
	var node = get_node(_find_task_node_path(json))
	
	node.get_node("ActionArea").enable()
	astronaut.get_node("Compass").target = node.get_path()
	
	has_task = true

func clear_task():
	var ui = get_tree().root.get_node("UI")
	ui.clear_task_box()
	
	var astronaut = get_tree().root.get_node("World/Astronaut")
	astronaut.get_node("Compass").target = ""
	has_task = false

func task_success():
	clear_task()
	completed_tasks += 1

func task_fail():
	clear_task()
	failed_tasks += 1

func end(fail, survived_days):
	get_node("/root/UI/Vertical").hide()
	get_node("/root/UI/EndCard").show()
	
	var vertical = get_node("/root/UI/EndCard/Panel/Margin/Vertical")
	vertical.get_node("SuccessfulTasks/Value").text = "%s" % completed_tasks
	vertical.get_node("FailedTasks/Value").text = "%s" % failed_tasks
	vertical.get_node("Ranking").visible_count = _calculate_ranking(completed_tasks, failed_tasks, survived_days)
	vertical.get_node("Survived").text = "Survived %s days" % survived_days
	
	get_node("/root/World/Astronaut").freeze()
	
	if fail:
		vertical.get_node("Label").text = "Mission failed!"

func _ready():
	_init_nodes()

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if has_task:
		task_deadline -= delta
		task_deadline = clamp(task_deadline, 0, 9999)
		get_node("/root/UI/Vertical/Task/Margin/Vertical/Deadline/Value").text = "%s seconds" % int(task_deadline)
		
		if task_deadline <=0:
			task_fail()

func _init_nodes():
	var world = world_scene.instance();
	var ui = ui_scene.instance();
	
	get_tree().root.call_deferred("add_child",ui)
	get_tree().root.call_deferred("add_child",world)

func _find_task_node_path(task):
	match task["tag"]:
		"gen-crate":
			if get_node_or_null("/root/World/Crate") == null:
				var crate = crate_scene.instance()
				var a = randf() * TAU
				get_node("/root/World").add_child(crate)
				crate.global_transform.origin = Vector3(cos(a)*60,20,sin(a)*60)
	
	var root = get_tree().root.get_node("World/%s" % task["selector"]["node"])
	
	match task["selector"]["type"]:
		"random":
			var child_count = root.get_child_count()
			var index = randi() % child_count
			return root.get_child(index).get_path()
		"specific":
			return root.get_path()
	return null

func _calculate_ranking(completed, failed, days):
	var result = completed - failed
	
	if days < get_node("/root/World").max_days:
		return 1
	else:
		return clamp(result, 1, 5)
