# Represents a "spawn slot" for a single enemy
@abstract
extends Resource
class_name BaseEnemySpawn

@abstract
func instantiate_enemy(rand: RandomNumberGenerator, params: EnemySpawnParams) -> Node2D
