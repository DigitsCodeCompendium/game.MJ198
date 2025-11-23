extends Node

@export var speed_control: SpeedControl

@export var asteroid_spawn_pattern: BaseEnemySpawnPattern
@export var asteroid_spawn_timer_curve: Curve

@export var persistent_spawn_pattern: BaseEnemySpawnPattern
@export var persistent_spawn_timer: float = 5

@onready var rand = RandomNumberGenerator.new()

@onready var screen_size = get_parent().get_viewport_rect().size
@onready var playable_margins = 0.125 * get_viewport().size.x

func _ready():
	_asteroid_spawn_loop()
	_persistent_spawn_loop()

func _asteroid_spawn_loop():
	while true:
		await get_tree().create_timer(asteroid_spawn_timer_curve.sample(speed_control.relativistic_speed)).timeout
		
		asteroid_spawn_pattern.do_spawn(
			get_parent(),
			Vector2(rand.randf_range(playable_margins, screen_size.x - playable_margins), 20),
			rand,
			_make_spawn_params()
		)

func _persistent_spawn_loop():
	while true:
		await get_tree().create_timer(persistent_spawn_timer).timeout
		
		persistent_spawn_pattern.do_spawn(
			get_parent(),
			Vector2(rand.randf_range(playable_margins, screen_size.x - playable_margins), 100),
			rand,
			_make_spawn_params()
		)

func _make_spawn_params() -> EnemySpawnParams:
		var params = EnemySpawnParams.new()
		params.linear_speed = speed_control.linear_speed
		params.relativistic_speed = speed_control.relativistic_speed
		return params
