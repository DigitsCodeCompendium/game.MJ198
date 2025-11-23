extends BaseEnemySpawnPattern
class_name AsteroidSpawnPattern

@export var asteroid_scene: PackedScene
@export var horizontal_speed_range: float = 10
@export var min_vertical_speed: float = 100
@export var max_vertical_speed: float = 200
@export var linear_speed_scale: float = 1

func do_spawn(parent: Node2D, position: Vector2, rand: RandomNumberGenerator):
	var asteroid = asteroid_scene.instantiate()
	var speed_control: SpeedControl = parent.get_node("/root/Game/SpeedControl")
	
	var screen_size = parent.get_viewport_rect().size
	var playable_margins = 0.125 * parent.get_viewport().size.x
	
	var velocity_x = rand.randf_range(-horizontal_speed_range, horizontal_speed_range)
	var velocity_y = lerpf(min_vertical_speed, max_vertical_speed, 1 - exp(-speed_control.linear_speed * linear_speed_scale))
	
	parent.add_child(asteroid)
	asteroid.launch(
		Vector2(velocity_x, velocity_y),
		Vector2(rand.randf_range(playable_margins, screen_size.x-playable_margins), -20),
		rand.randf_range(1, 5)
	)
	
