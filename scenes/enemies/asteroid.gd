extends Node2D

var velocity: Vector2
var ang_velocity: float
var base_health = 10
var _marked_for_death = false

@onready var death_sound = get_node("%DeathSoundPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered",_on_asteroid_collision)
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	$Health.connect("health_depleted", _death)

func launch(vel:Vector2, pos:Vector2, size:float) -> void:
	self.position = pos
	self.velocity = vel
	self.scale = Vector2(size, size)
	self.ang_velocity = randf_range(-2, 2)
	$Health.max_health = self.scale.x * base_health
	$Health.reset_health()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	$AnimatedSprite2D.rotation += ang_velocity * delta
	
	if _marked_for_death and not death_sound.playing:
		self.queue_free()

func _on_leave_screen():
	_marked_for_death = true

func _on_asteroid_collision(area: Area2D):
	if area.is_in_group("player"):
		# TODO murder player
		pass
	
	elif area.is_in_group("player_projectile"):
		$Health.damage(area.damage)
		area.hit()
	
func _death():
	#Hide sprite
	$AnimatedSprite2D.visible = false
	
	#Spawn Fragments
	if self.scale.x > 3:
		var fragments = floor(self.scale.length()) - 2
		for i in fragments:
			var new_velocity = Vector2(self.velocity.x*randf_range(-0.5,0.5)*ang_velocity*10,self.velocity.y*randf_range(0.5,0.8))
			var new_position = self.position + Vector2(10*self.scale.x*randf_range(-1,1),10*self.scale.x*randf_range(-1,1))
			var fragment = self.duplicate()
			fragment.launch(new_velocity,new_position,self.scale.x/fragments)
			get_parent().call_deferred("add_child",fragment)
		
	#Spawn Pickup	
	var pickup = $PickupDropSource.create_pickup()
	if pickup != null:
		pickup.position = self.position + Vector2(10*self.scale.x*randf_range(-1,1),10*self.scale.x*randf_range(-1,1))
		pickup.velocity = Vector2(self.velocity.x*randf_range(-0.5,0.5)*ang_velocity*10,self.velocity.y*randf_range(0.5,0.8))
		get_parent().call_deferred("add_child", pickup)
	
	#Play animations
	
	#Play sound effects
	death_sound.play()
	
	_marked_for_death = true
	
