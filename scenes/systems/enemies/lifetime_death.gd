extends Node

@export var lifetime = 10

func _ready():
	var death_timer = get_tree().create_timer(lifetime)
	await death_timer.timeout
	owner.queue_free()
