extends Area2D

var accel_accel = Vector2.ZERO
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var _damage: float
var damage: float:
	get: return _damage * velocity.length() * speed_damage_rate
var pierce: float

@export var speed_damage_rate: float #damage will be base_damage * speed * speed_damage_rate

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

func launch(accel:Vector2, pos:Vector2, size:float, dmg:float, group:String, weapon_sys:WeaponSystem) -> void:
	self.add_to_group(group)
	self.position = pos
	self.acceleration = accel
	self.scale = Vector2(size, size)
	self._damage = dmg
	self.pierce = weapon_sys.module_system.get_module_property("weapon_pierce")

func hit():
	if self.pierce >= 1:
		self.pierce -= 1
	else:
		if self.pierce > 0:
			if self.pierce > randf_range(0, 1):
				self.pierce = 0
		else:
			self.queue_free()

func _on_leave_screen():
	self.queue_free()
