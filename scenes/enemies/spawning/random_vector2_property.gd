extends BaseRandomProperty
class_name RandomVector2Property

@export var min_value: Vector2
@export var max_value: Vector2
@export var diagonal: bool # If true, forces the vector to be a linear interpolation of min to max

func apply_property(target: Node, rand: RandomNumberGenerator):
	if diagonal:
		var t = rand.randf()
		target.set(property_name, min_value.lerp(max_value, t))
	else:
		var x = rand.randf_range(min_value.x, max_value.x)
		var y = rand.randf_range(min_value.y, max_value.y)
		target.set(property_name, Vector2(x, y))
