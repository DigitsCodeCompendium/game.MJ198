extends ProgressBar

@export var fuel_timer: Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = fuel_timer.time_left / fuel_timer.wait_time
