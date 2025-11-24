extends CollisionShape2D

@export var speed_control: SpeedControl

@export var spawn_pattern: BaseEnemySpawnPattern
@export var initial_delay: float = 5
@export var spawn_timer_curve: Curve
@export var min_linear_speed: float = 0
@export var max_linear_speed: float = INF

@onready var rand = RandomNumberGenerator.new()

@onready var screen_size = owner.get_viewport_rect().size
@onready var playable_margins = 0.125 * get_viewport().size.x

func _ready():
	while speed_control.linear_speed < min_linear_speed:
		await get_tree().create_timer(1).timeout
	
	await get_tree().create_timer(initial_delay).timeout
	
	while true:
		var spawn_rect = shape.get_rect()
		var x = rand.randf_range(-spawn_rect.size.x / 2, spawn_rect.size.x / 2)
		var y = rand.randf_range(-spawn_rect.size.y / 2, spawn_rect.size.y / 2)
		
		spawn_pattern.do_spawn(
			owner,
			Vector2(x, y) + global_position,
			rand,
			_make_spawn_params()
		)

		await get_tree().create_timer(spawn_timer_curve.sample(speed_control.relativistic_speed)).timeout
		
		if speed_control.linear_speed > max_linear_speed:
			return

func _make_spawn_params() -> EnemySpawnParams:
		var params = EnemySpawnParams.new()
		params.linear_speed = speed_control.linear_speed
		params.relativistic_speed = speed_control.relativistic_speed
		return params
