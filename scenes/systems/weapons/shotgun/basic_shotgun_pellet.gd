extends Area2D

var velocity = Vector2.ZERO
var damage: float
var pierce: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta

func launch(vel:Vector2, pos:Vector2, size:float, dmg:float, group:String, weapon_sys:WeaponSystem) -> void:
	self.add_to_group(group)
	self.position = pos
	self.velocity = vel
	self.scale = Vector2(size, size)
	self.damage = dmg
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
