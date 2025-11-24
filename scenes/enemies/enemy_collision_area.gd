extends Area2D

@export var health: EnemyHealth
@export var hit_sound: AudioStreamPlayer2D

signal player_collision()

func _ready():
	connect("area_entered", _on_collision)
	health.connect("health_depleted", _on_health_depleted)

func _on_collision(area: Area2D):
	if area.is_in_group("player"):
		player_collision.emit()
	
	elif area.is_in_group("player_projectile"):
		area.hit()
		health.damage(area.damage)
		if hit_sound != null:
			hit_sound.play()

func _on_health_depleted():
	$CollisionPolygon2D.queue_free()
