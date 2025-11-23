extends Node2D

var asteroid_scene = preload("res://scenes/enemies/asteroid.tscn")
var playable_margins: float
@export var spawn_timer = 0.5 #spawn timer of asteroids in seconds
var spawn_timer_time = 0

func _ready() -> void:
	playable_margins = 0.125*get_viewport().size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#spawn_timer_time += delta
	#
	#if spawn_timer_time > spawn_timer:
		#spawn_timer_time = 0
		#var screen_size = get_viewport_rect().size
		#
		#var asteroid = asteroid_scene.instantiate()
		#add_child(asteroid)
		#asteroid.launch(Vector2(randi_range(-10, 10), 200), Vector2(randi_range(playable_margins, screen_size.x-playable_margins),-20), randf_range(1, 5))
	
	if Input.is_action_just_pressed("test_key"):
		get_node("Player/Systems/ModuleSystem").set_module(0, load("res://resources/modules/firerate_module_1.tres"))
	
