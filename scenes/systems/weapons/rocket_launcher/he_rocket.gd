extends Area2D

var explosion_scene = preload("res://scenes/systems/weapons/rocket_launcher/he_rocket_explosion.tscn")
var accel_accel = Vector2.ZERO
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var damage: float
@export var explosion_damage_mult: float = 5

var _dead: bool = false

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
	
	if _dead:
		var explosion = explosion_scene.instantiate()
		explosion.launch(Vector2.ZERO, self.position, 2, self.damage * explosion_damage_mult , "player_projectile")
		get_node("/root").add_child(explosion)
		self.queue_free()

func launch(accel:Vector2, pos:Vector2, size:float, dmg:float, group:String) -> void:
	self.add_to_group(group)
	self.position = pos
	self.acceleration = accel
	self.scale = Vector2(size, size)
	self.damage = dmg

func hit():
	_dead = true

func _on_leave_screen():
	self.queue_free()
