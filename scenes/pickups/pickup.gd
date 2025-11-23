extends Area2D
class_name Pickup

@export var content: Resource
var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("area_entered", _on_area_entered)
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	
	if content is PickupContentPower:
		var visu_scene = content.get_visu_scene().instantiate()
		self.add_child(visu_scene)
		$Icon.queue_free()
	else:
		$Icon.texture = content.get_icon()

func _on_area_entered(area: Area2D):
	if area.is_in_group("player") and content != null:
		content.apply_to_player(area)
		self.queue_free()

func _process(delta):
	self.position += velocity * delta

func _on_leave_screen():
	self.queue_free()
