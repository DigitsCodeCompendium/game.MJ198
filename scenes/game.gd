extends Node2D

var asteroid_scene = preload("res://scenes/enemies/asteroid.tscn")
var playable_margins: float
@export var spawn_timer = 0.5 #spawn timer of asteroids in seconds
var spawn_timer_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer_time += delta
	
	playable_margins = 0.125*get_viewport().size.x
	
	if spawn_timer_time > spawn_timer:
		spawn_timer_time = 0
		
		var screen_size = get_viewport_rect().size
		
		var asteroid = asteroid_scene.instantiate()
		add_child(asteroid)
		asteroid.launch(Vector2(randi_range(-10, 10), 200), Vector2(randi_range(playable_margins, screen_size.x-playable_margins),-20), randf_range(1, 5))
	pass
	
