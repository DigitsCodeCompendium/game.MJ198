extends Node2D

@export var pickup_item_scene: PackedScene = preload("res://scenes/pickups/pickup.tscn")
@export var drop_table: Dictionary[Resource, int]

func create_pickup() -> Pickup:
	var random = RandomNumberGenerator.new()
	var contents = drop_table.keys()
	var weights = contents.map(func(content): return drop_table[content])
	var drop_content = contents[random.rand_weighted(weights)]
	
	if drop_content == null:
		return null
	
	var pickup_item = pickup_item_scene.instantiate()
	pickup_item.content = drop_content
	return pickup_item
