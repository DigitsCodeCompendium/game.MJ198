extends Area2D

@export var health: EnemyHealth

signal player_collision()

func _ready():
	connect("area_entered", _on_collision)

func _on_collision(area: Area2D):
	if area.is_in_group("player"):
		player_collision.emit()
	
	elif area.is_in_group("player_projectile"):
		area.hit()
		health.damage(area.damage)
