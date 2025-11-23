extends Area2D

var damage: float
var time_till_death: float
var explosion_time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_till_death -= delta
	explosion_time -= delta
	if explosion_time < 0:
		#$CollisionShape2D.queue_free()
		pass
	if time_till_death < 0:
		self.queue_free()

func launch(_accel:Vector2, pos:Vector2, size:float, dmg:float, group:String, _weapon_system) -> void:
	self.add_to_group(group)
	self.position = pos
	self.scale = Vector2(size, size)
	self.damage = dmg
	self.time_till_death = 1
	self.explosion_time = 0.1

func hit():
	pass
