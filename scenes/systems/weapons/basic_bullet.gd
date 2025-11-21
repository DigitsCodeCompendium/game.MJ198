extends Area2D

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta

func launch(vel:Vector2, pos:Vector2, size:float) -> void:
	self.position = pos
	self.velocity = vel
	self.scale = Vector2(size, size)

func hit():
	self.queue_free()
