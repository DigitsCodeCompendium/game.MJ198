@abstract
extends Resource
class_name BaseRandomProperty

@export var property_name: String

@abstract
func apply_property(target: Node, rand: RandomNumberGenerator)
