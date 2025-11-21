extends Node2D

var velocity: Vector2
var ang_velocity: float
var health: float
var base_health = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered",_on_asteroid_collision)
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_leave_screen)
	pass # Replace with function body.

func launch(vel:Vector2, pos:Vector2, size:float) -> void:
	self.position = pos
	self.velocity = vel
	self.scale = Vector2(size, size)
	self.health = self.scale.x * base_health
	self.ang_velocity = randf_range(-2, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	rotation += ang_velocity * delta

func _on_leave_screen():
	self.queue_free()

func _on_asteroid_collision(area: Area2D):
	if area.is_in_group("player") or area.is_in_group("player_projectile"):
		if area.is_in_group("player_projectile"):
			area.hit()
		
		self.health -= 200
		
		if self.health <= 0:
			death()
	
func death():
	if self.scale.x > 3:
		var fragments = floor(self.scale.length()) - 2
		for i in fragments:
			var new_velocity = Vector2(self.velocity.x*randf_range(-0.5,0.5)*ang_velocity*10,self.velocity.y*randf_range(0.5,0.8))
			var new_position = self.position + Vector2(10*self.scale.x*randf_range(-1,1),10*self.scale.x*randf_range(-1,1))
			var fragment = self.duplicate()
			fragment.launch(new_velocity,new_position,self.scale.x/fragments)
			self.get_parent().add_child(fragment)
	#Play some sort of explosion effect
	self.queue_free()
	
