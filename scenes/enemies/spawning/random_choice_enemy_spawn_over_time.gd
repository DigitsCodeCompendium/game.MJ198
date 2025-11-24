extends BaseEnemySpawn
class_name RandomEnemySpawnOverTime

@export var spawn_table: Dictionary[PackedScene, Curve] = {}
@export var use_linear_speed: bool

func instantiate_enemy(rand: RandomNumberGenerator, params: EnemySpawnParams):
	assert(len(spawn_table) > 0)
	var enemies = spawn_table.keys()
	var speed = params.linear_speed if use_linear_speed else params.relativistic_speed
	var weights = enemies.map(func(e): return spawn_table[e].sample(speed))
	var enemy_scene = enemies[rand.rand_weighted(weights)]
	
	if enemy_scene == null:
		return null
	
	return enemy_scene.instantiate()
