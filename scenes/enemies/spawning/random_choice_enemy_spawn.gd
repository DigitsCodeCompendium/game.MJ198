extends BaseEnemySpawn
class_name RandomEnemySpawn

@export var spawn_table: Dictionary[PackedScene, float] = {}

func instantiate_enemy(rand: RandomNumberGenerator):
	assert(len(spawn_table) > 0)
	var enemies = spawn_table.keys()
	var weights = enemies.map(func(e): return spawn_table[e])
	var enemy_scene = enemies[rand.rand_weighted(weights)]
	
	if enemy_scene == null:
		return null
	
	return enemy_scene.instantiate()
