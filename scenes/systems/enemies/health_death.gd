extends Node

@export var health: Node
@export var animated_sprite: AnimatedSprite2D
@export var fade_away_time: float = 0
var _fade_time: float
var _marked_dead: bool = false
var _death_anim_done: bool = false

signal on_death()
signal on_death_finish()

func _ready():
	health.connect("health_depleted", _on_health_depleted)
	animated_sprite.connect("animation_finished", _on_anim_finished)
	_fade_time = fade_away_time

func _on_health_depleted():
	_marked_dead = true
	animated_sprite.play("death")
	on_death.emit()
	
func _on_anim_finished():
	if animated_sprite.animation == "death":
		_death_anim_done = true
	
func _process(delta: float) -> void:
	if _death_anim_done:
		_fade_time -= delta
		if _fade_time < 0:
			on_death_finish.emit()
			owner.queue_free()
		else:
			animated_sprite.self_modulate.a = _fade_time/fade_away_time
