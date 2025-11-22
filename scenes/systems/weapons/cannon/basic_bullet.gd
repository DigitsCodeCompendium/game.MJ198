extends Area2D

var velocity = Vector2.ZERO
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta

func launch(vel:Vector2, pos:Vector2, size:float, dmg:int, group:String) -> void:
	self.add_to_group(group)
	self.position = pos
	self.velocity = vel
	self.scale = Vector2(size, size)
	self.damage = dmg

func hit():
	self.queue_free()

func _on_leave_screen():
	self.queue_free()
