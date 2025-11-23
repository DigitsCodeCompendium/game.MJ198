extends BaseRandomProperty
class_name RandomIntProperty

@export var min_value: int
@export var max_value: int

func apply_property(target: Node, rand: RandomNumberGenerator):
	target.set(property_name, rand.randi_range(min_value, max_value))
