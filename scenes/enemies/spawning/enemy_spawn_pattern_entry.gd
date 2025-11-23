extends Resource
class_name EnemySpawnPatternEntry

@export var enemy_spawn: BaseEnemySpawn # The source for the enemy
@export var base_offset: Vector2 # The base offset to apply
@export var random_offset: Vector2 # Random offset on top of base offset. Interpretation depends on normal_dist
@export var normal_dist: bool # If true, random offset is a normal distribution with the components as stdev. If false, random offset is in a box from (-x,-y) to (x,y).
