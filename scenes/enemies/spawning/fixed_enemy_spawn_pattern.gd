# represents a group of enemies attempting to spawn
# for example, a square formation of enemies
extends BaseEnemySpawnPattern
class_name FixedEnemySpawnPattern

@export var pattern: Array[EnemySpawnPatternEntry] = []

func do_spawn(parent: Node2D, position: Vector2, rand: RandomNumberGenerator):
	for entry in pattern:
		var enemy = entry.enemy_spawn.instantiate_enemy(rand)
		if enemy == null:
			continue
		
		var offset = entry.base_offset
		if entry.normal_dist:
			offset += Vector2(rand.randfn(0, entry.random_offset.x), rand.randfn(0, entry.rand_offset.y))
		else:
			offset += Vector2(rand.randf_range(-entry.random_offset.x, entry.random_offset.x), rand.randf_range(-entry.random_offset.y, entry.random_offset.y))
		
		enemy.position = position + offset
		parent.add_child(enemy)
		print("Spawning %s at %s" % [enemy.name, enemy.position])
