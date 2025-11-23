extends Node2D

var rotaion_vel: float = 0
var velocity: Vector2 = Vector2.ZERO
var decay_time: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += rotaion_vel * delta
	position += velocity * delta
	decay_time -= delta
	if decay_time < 1:
		$Sprite2D.self_modulate.a = decay_time
	if decay_time < 0:
		self.queue_free()
