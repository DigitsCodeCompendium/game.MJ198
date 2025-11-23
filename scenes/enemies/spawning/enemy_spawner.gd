extends Node

@export var asteroid_spawn_pattern: BaseEnemySpawnPattern
@export var beginner_enemy_spawn_pattern: BaseEnemySpawnPattern

@export var asteroid_spawn_timer: float = 2
var _spawn_timer = 0

@export var enemy_spawn_timer: float = 5

@onready var rand = RandomNumberGenerator.new()

func _ready():
	var screen_size = get_parent().get_viewport_rect().size
	var playable_margins = 0.125 * get_viewport().size.x
	
	while true:
		await get_tree().create_timer(enemy_spawn_timer).timeout
		beginner_enemy_spawn_pattern.do_spawn(get_parent(), Vector2(rand.randf_range(playable_margins, screen_size.x - playable_margins), 100), rand)

func _process(delta):
	_spawn_timer += delta
	
	if _spawn_timer > asteroid_spawn_timer:
		_spawn_timer -= asteroid_spawn_timer
	
		var screen_size = get_parent().get_viewport_rect().size
		var playable_margins = 0.125 * get_viewport().size.x
		
		asteroid_spawn_pattern.do_spawn(get_parent(), Vector2(rand.randf_range(playable_margins, screen_size.x - playable_margins), 20), rand)
