extends Node

@onready var player: Node2D = get_node("/root/Game/Player")

@export var acceleration = 50
@export var rotation_speed = 60
@export var area: Area2D

var _velocity: Vector2 = Vector2.ZERO

func _process(delta):
	owner.position += _velocity * delta
	
	var target_dir: Vector2 = player.global_position - owner.global_position
	var rot_diff = angle_difference(area.rotation, target_dir.angle()) + PI/2
	var rotation_limit = rotation_speed * delta * PI / 180
	area.rotate(clampf(rot_diff, -rotation_limit, rotation_limit))
	
	_velocity += area.transform.x.normalized() * acceleration * delta
