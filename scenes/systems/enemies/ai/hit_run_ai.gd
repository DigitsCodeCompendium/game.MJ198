extends Node

@onready var player: Node2D = get_node("/root/Game/Player")

@export var weapon_systems: Array[WeaponSystem]
@export var break_off_dist: float
@export var engage_dist: float
@export var rotation_speed: float
@export var speed: float
@export var area: Area2D

var _is_hitting: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	owner.position += Vector2.UP.rotated(area.rotation) * speed * delta
	
	var target_dir: Vector2 = player.global_position - owner.global_position
	var rot_diff: float
	
	var target_dist: float = target_dir.length()
	if _is_hitting:
		if target_dist < break_off_dist:
			_is_hitting = false
		for weapon_system in weapon_systems:
			weapon_system.fire( Vector2.UP.rotated(area.rotation))
		rot_diff = angle_difference(area.rotation, target_dir.angle()) + PI/2
	else:
		if target_dist > engage_dist:
			_is_hitting = true
		rot_diff = angle_difference(area.rotation, target_dir.angle()+PI) + PI/2
	
	var rotation_limit = rotation_speed * delta * PI / 180
	area.rotate(clampf(rot_diff, -rotation_limit, rotation_limit))
