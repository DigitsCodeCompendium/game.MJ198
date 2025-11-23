extends Area2D

var shrapnel_scene = preload("res://scenes/systems/weapons/shotgun/basic_shotgun_pellet.tscn")
var accel_accel = Vector2.ZERO
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var damage: float

var _dead: bool

@export var shrapnel_amount = 10
@export var shrapnel_speed = 300
@export var shrapnel_dmg_perc = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_dead = false
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acceleration += accel_accel * delta
	velocity += acceleration * delta
	position += velocity * delta
	rotation = velocity.angle() + PI/2
	
	if _dead:
		for i in range(shrapnel_amount):
			var shrapnel = shrapnel_scene.instantiate()
			var angle = randf_range(0, 2*PI)
			shrapnel.launch(shrapnel_speed * Vector2.UP.rotated(angle), self.position, 1, shrapnel_dmg_perc * damage, "player_projectile")
			get_node("/root").add_child(shrapnel)
		self.queue_free()

func launch(accel:Vector2, pos:Vector2, size:float, dmg:float, group:String, weapon_sys:WeaponSystem) -> void:
	self.add_to_group(group)
	self.position = pos
	self.acceleration = accel
	self.scale = Vector2(size, size)
	self.damage = dmg

func hit():
	_dead = true

func _on_leave_screen():
	self.queue_free()
