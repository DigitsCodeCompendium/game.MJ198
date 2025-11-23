extends BaseRandomProperty
class_name RandomNormalFloatProperty

@export var mean: float
@export var stdev: float

func apply_property(target: Node, rand: RandomNumberGenerator):
	target.set(property_name, rand.randfn(mean, stdev))
