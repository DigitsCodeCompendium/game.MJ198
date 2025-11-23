extends BaseEnemySpawn
class_name RandomPropertyEnemySpawn

@export var enemy_spawn: BaseEnemySpawn
@export var random_properties: Array[BaseRandomProperty] = []

func instantiate_enemy(rand: RandomNumberGenerator):
	var enemy = enemy_spawn.instantiate_enemy(rand)
	if enemy == null:
		return null
	
	for random_property in random_properties:
		random_property.apply_property(enemy, rand)
	
	return enemy
