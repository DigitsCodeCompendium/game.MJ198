extends BaseEnemySpawnPattern
class_name AsteroidSpawnPattern

@export var asteroid_scenes: Array[PackedScene]
@export var horizontal_speed_range: float = 10
@export var vertical_speed_curve: Curve
@export var min_scale_curve: Curve
@export var max_scale_curve: Curve

func do_spawn(parent: Node2D, position: Vector2, rand: RandomNumberGenerator, params: EnemySpawnParams):
	var asteroid = asteroid_scenes.pick_random().instantiate()
	
	var velocity_x = rand.randf_range(-horizontal_speed_range, horizontal_speed_range)
	var velocity_y = vertical_speed_curve.sample(params.linear_speed)
	var scale = rand.randf_range(min_scale_curve.sample(params.relativistic_speed), max_scale_curve.sample(params.relativistic_speed))
	
	parent.add_child(asteroid)
	asteroid.launch(
		Vector2(velocity_x, velocity_y),
	 	position,
		scale
	)
	
