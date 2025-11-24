extends Node
class_name SpeedControl

@export var linear_acceleration: float = 0.1

var linear_speed: float = 0 # linear speed of 1 = 0.9c, linear speed of 2 = 0.99c
var relativistic_speed: float:
	get:
		return 1 - exp(-linear_speed * log(10))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_speed_display() -> String:
	# Technically speed = tanh(t), but I'm using speed = 1 - 0.1^t
	# Within a constant factor in front of t, they look close enough that people probably can't tell the difference.
	
	var num_nines = int(linear_speed)
	var nines = []
	for i in range(num_nines):
		nines.append("9")
	var last_part = 1 - exp(-(linear_speed - num_nines) * log(10))
	return "0." + "".join(nines) + ("%.2f" % last_part).substr(2) + "c"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_speed += linear_acceleration * delta
	UiEventBus.emit_signal("current_speed",get_speed_display())
