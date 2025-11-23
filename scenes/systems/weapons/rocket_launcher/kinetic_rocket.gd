extends Area2D

var accel_accel = Vector2.ZERO
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var damage: float:
	get: return damage * velocity.length()/100
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acceleration += accel_accel * delta
	velocity += acceleration * delta
	position += velocity * delta
	rotation = velocity.angle() + PI/2

func launch(accel:Vector2, pos:Vector2, size:float, dmg:float, group:String) -> void:
	self.add_to_group(group)
	self.position = pos
	self.acceleration = accel
	self.scale = Vector2(size, size)
	self.damage = dmg

func hit():
	self.queue_free()

func _on_leave_screen():
	self.queue_free()
