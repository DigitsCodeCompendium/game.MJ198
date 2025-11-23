extends Node

@export var asteroid_spawn_pattern: BaseEnemySpawnPattern

@export var asteroid_spawn_timer: float = 2
var _spawn_timer = 0

@onready var rand = RandomNumberGenerator.new()

func _process(delta):
	_spawn_timer += delta
	
	if _spawn_timer > asteroid_spawn_timer:
		_spawn_timer -= asteroid_spawn_timer
		
		asteroid_spawn_pattern.do_spawn(get_parent(), Vector2(700, 20), rand)
