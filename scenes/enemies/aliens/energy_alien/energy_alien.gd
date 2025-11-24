extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	if $Area2D/AnimatedSprite2D.animation == "warp_in":
		$Area2D/AnimatedSprite2D.play("default")
	elif $Area2D/AnimatedSprite2D.animation == "warp_out":
		queue_free()

func _on_timer_timeout() -> void:
	$Area2D/AnimatedSprite2D.play("warp_out")
