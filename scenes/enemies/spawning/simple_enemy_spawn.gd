extends BaseEnemySpawn
class_name SimpleEnemySpawn

@export var enemy: PackedScene

func instantiate_enemy(_rand: RandomNumberGenerator):
	return enemy.instantiate()
