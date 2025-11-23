extends Node

@onready var player: Node2D = get_node("/root/Game/Player")

@export var acceleration = 1
@export var rotation_speed = 60
@export var area: Area2D

var _velocity: Vector2 = Vector2.ZERO

func _process(delta):
	owner.position += _velocity * delta
	
	var target_rotation = area.get_angle_to(player.global_position - owner.global_position)
	var rotation_limit = rotation_speed * delta * PI / 180
	area.rotate(clampf(target_rotation, -rotation_limit, rotation_limit))
	
	_velocity += area.transform.y.normalized() * acceleration * delta
