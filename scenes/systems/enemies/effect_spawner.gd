extends Node

@export var effects: Array[PackedScene] = []

func spawn_effects():
	for effect_scene in effects:
		var effect = effect_scene.instantiate()
		effect.position = owner.position
		owner.get_parent().add_child(effect)
