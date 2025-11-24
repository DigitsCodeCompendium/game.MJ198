extends Node2D

var velocity: Vector2
var ang_velocity: float
var base_health = 9
var _marked_for_death = false

@export var hit_sound: AudioStreamPlayer2D

@onready var death_sound = get_node("%DeathSoundPlayer")
@onready var possible_fragment_scene = [
load("res://scenes/enemies/asteroids/asteroid1.tscn"),
load("res://scenes/enemies/asteroids/asteroid2.tscn"),
load("res://scenes/enemies/asteroids/asteroid3.tscn"),
load("res://scenes/enemies/asteroids/asteroid4.tscn"),
load("res://scenes/enemies/asteroids/asteroid5.tscn"),
load("res://scenes/enemies/asteroids/asteroid6.tscn"),
load("res://scenes/enemies/asteroids/asteroid7.tscn"),
load("res://scenes/enemies/asteroids/asteroid8.tscn")
]

var fragment_posibilities = [0.140625, 0.015625, 0.140625, 0.140625, 0.140625, 0.140625, 0.140625, 0.140625, 0.140625]

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
	if $AnimatedSprite2D.self_modulate.a < 1:
		$AnimatedSprite2D.self_modulate.a += delta
	
	
	position += velocity * delta
	$AnimatedSprite2D.rotation += ang_velocity * delta
	if $CollisionShape2D != null:
		$CollisionShape2D.rotation += ang_velocity * delta
	if _marked_for_death and not death_sound.playing:
		self.queue_free()

func _on_leave_screen():
	_marked_for_death = true

func _on_asteroid_collision(area: Area2D):
	if area.is_in_group("player"):
		# TODO murder player
		pass
	
	elif area.is_in_group("player_projectile"):
		area.hit()
		$Health.damage(area.damage)
		hit_sound.play()
	
func _death():
	#Hide sprite
	$CollisionShape2D.queue_free()
	
	#Spawn Fragments
	if self.scale.x > 3:
		var fragments = floor(self.scale.length()) - 2
		for i in fragments:
			var new_velocity = Vector2(self.velocity.x*randf_range(-0.5,0.5)*ang_velocity*10,self.velocity.y*randf_range(0.5,0.8))
			var new_position = self.position + Vector2(10*self.scale.x*randf_range(-1,1),10*self.scale.x*randf_range(-1,1))
			var fragment = possible_fragment_scene.pick_random().instantiate()
			fragment.launch(new_velocity,new_position,self.scale.x/fragments)
			fragment.get_node("AnimatedSprite2D").self_modulate.a = 0
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
	


func _on_health_death_on_death_finish() -> void:
	pass # Replace with function body.
