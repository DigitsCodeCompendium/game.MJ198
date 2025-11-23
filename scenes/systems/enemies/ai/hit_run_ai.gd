extends Node

@onready var player: Node2D = get_node("/root/Game/Player")

@export var death_sources: Array[Node]

@export var weapon_systems: Array[WeaponSystem]
@export var break_off_dist: float
@export var engage_dist: float
@export var rotation_speed: float
@export var speed: float
@export var area: Area2D

var _is_hitting: bool = true
var _brain_dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for death_source in death_sources:
		death_source.connect("on_death", _on_death)
	pass # Replace with function body.

func _on_death():
	_brain_dead = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	owner.position += Vector2.UP.rotated(area.rotation) * speed * delta
	
	#Clamp to visivle area
	owner.position.x = clamp(owner.position.x,160,get_viewport().size.x-160)
	
	var target_dir: Vector2 = player.global_position - owner.global_position
	var rot_diff: float
	
	var target_dist: float = target_dir.length()
	if _is_hitting:
		if target_dist < break_off_dist:
			_is_hitting = false
		if not _brain_dead:
			for weapon_system in weapon_systems:
				weapon_system.fire( Vector2.UP.rotated(area.rotation))
		rot_diff = angle_difference(area.rotation, target_dir.angle()) + PI/2
	else:
		if target_dist > engage_dist:
			_is_hitting = true
		rot_diff = angle_difference(area.rotation, target_dir.angle()+PI) + PI/2
	
	var rotation_limit = rotation_speed * delta * PI / 180
	if not _brain_dead:
		area.rotate(clampf(rot_diff, -rotation_limit, rotation_limit))
