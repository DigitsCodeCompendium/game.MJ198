extends VisibleOnScreenNotifier2D

func _ready():
	connect("screen_exited", _die)

func _die():
	owner.queue_free()
