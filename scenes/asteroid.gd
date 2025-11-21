extends Node2D

var velocity: Vector2
var ang_velocity: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	pass # Replace with function body.

func launch(vel:Vector2, pos:int, size:float) -> void:
	self.position.y = -20
	self.position.x = pos
	self.velocity = vel
	self.scale = Vector2(size, size)
	self.ang_velocity = randf_range(-2, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	rotation += ang_velocity * delta

func _on_leave_screen():
	self.queue_free()
