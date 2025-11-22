extends Area2D

var velocity = Vector2.ZERO
var damage: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	rotation = velocity.angle() + PI/2

func launch(vel:Vector2, pos:Vector2, size:float, dmg:float, group:String) -> void:
	self.add_to_group(group)
	self.position = pos
	self.velocity = vel
	self.scale = Vector2(size, size)
	self.damage = dmg

func hit():
	self.queue_free()

func _on_leave_screen():
	self.queue_free()
