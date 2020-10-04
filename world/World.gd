extends Spatial

export var environment : Environment
export var day_time : float
export var max_days : int

var time = 0.0
var sky_color

func elapsed_days():
	return max_days - days_left()

func days_left():
	return int(max_days - time / (day_time*2))

func _ready():
	sky_color = environment.background_color

func _process(delta):
	var day_period = (sin((time / day_time) * PI) + 1.0) * 0.5
	$Light.light_energy = day_period * 0.5
	environment.ambient_light_energy = clamp(day_period, 0.05, 1)
	
	environment.background_color = sky_color * day_period
	environment.background_color.a = 1
	
	environment.fog_color = sky_color * day_period
	environment.fog_color.a = 1
	
	var day_label = get_node("/root/UI/Vertical/Mission/Margin/Vertical/Time/Value")
	day_label.text = "%s days remaining" % days_left()
	
	if days_left() > 0:
		time += delta
	else:
		Manager.end(false, elapsed_days())
