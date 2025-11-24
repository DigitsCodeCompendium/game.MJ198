extends Node

@export var weapon_system: WeaponSystem
@export var strafe_weapon_sys: WeaponSystem
@onready var player = get_node("/root/Game/Player")
@export var top: Node2D

var state: AiState
var state_change_cooldown: float = 0
@export
var to_strafing_min_time: float = 10
@export
var to_straging_max_time: float = 20

var target_pos: Vector2 = Vector2.ZERO
var starting_pos: Vector2
@export
var pos_threshold: float = 10
@export
var speed: float = 300

enum AiState {
	SHOOTING = 0,
	GOING_TO_STRAFE = 1,
	STRAFING_LEFT = 2,
	STRAFING_RIGHT = 3,
	STRAFING_RETURN = 4,
	RETURNING_FROM_STRAFE = 5,
	DEAD = 6
}

func _change_to_shooting():
	state = AiState.SHOOTING
	state_change_cooldown = randf_range(to_strafing_min_time, to_straging_max_time)

func _change_to_strafing():
	state = AiState.GOING_TO_STRAFE
	starting_pos = top.position
	state_change_cooldown = 0

func _ready() -> void:
	_change_to_shooting()

func _process(delta):
	var dir: Vector2 = player.position - weapon_system.owner.position
	
	if state == AiState.SHOOTING:
		state_change_cooldown -= delta
		weapon_system.fire(dir.normalized())
		print(state_change_cooldown)
		if state_change_cooldown < 0:
			_change_to_strafing()
	
	elif state == AiState.GOING_TO_STRAFE:
		var y_pos = get_viewport().size.y
		target_pos = Vector2(starting_pos.x, y_pos)
		
		var velocity = (target_pos - top.position).normalized() * speed
		top.position += velocity * delta
		
		if (top.position - target_pos).length() < pos_threshold:
			state = AiState.STRAFING_LEFT
		
	elif state == AiState.STRAFING_LEFT:
		strafe_weapon_sys.fire(Vector2.UP)
		var y_pos = get_viewport().size.y
		target_pos = Vector2(0, y_pos)
		
		var velocity = (target_pos - top.position).normalized() * speed
		top.position += velocity * delta
		
		if (top.position - target_pos).length() < pos_threshold:
			state = AiState.STRAFING_RIGHT
	
	elif state == AiState.STRAFING_RIGHT:
		strafe_weapon_sys.fire(Vector2.UP)
		var y_pos = get_viewport().size.y
		var x_pos = get_viewport().size.x
		target_pos = Vector2(x_pos, y_pos)
		
		var velocity = (target_pos - top.position).normalized() * speed
		top.position += velocity * delta
		
		if (top.position - target_pos).length() < pos_threshold:
			state = AiState.STRAFING_RETURN
	
	elif state == AiState.STRAFING_RETURN:
		strafe_weapon_sys.fire(Vector2.UP)
		var y_pos = get_viewport().size.y
		target_pos = Vector2(starting_pos.x, y_pos)
		
		var velocity = (target_pos - top.position).normalized() * speed
		top.position += velocity * delta
		
		if (top.position - target_pos).length() < pos_threshold:
			state = AiState.RETURNING_FROM_STRAFE
	
	elif state == AiState.RETURNING_FROM_STRAFE:
		target_pos = starting_pos
		
		var velocity = (target_pos - top.position).normalized() * speed
		top.position += velocity * delta
		
		if (top.position - target_pos).length() < pos_threshold:
			_change_to_shooting()
	
	else:
		pass
