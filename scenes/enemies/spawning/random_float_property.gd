extends BaseRandomProperty
class_name RandomFloatProperty

@export var min_value: float
@export var max_value: float

func apply_property(target: Node, rand: RandomNumberGenerator):
	target.set(property_name, rand.randf_range(min_value, max_value))
