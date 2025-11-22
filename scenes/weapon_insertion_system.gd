extends Node

@export var weapon_system: WeaponSystem

@export var pickup_keep_time: float = 5

var _pending_weapon: Shootable
var _pending_remaining_time: float

func _ready():
	_pending_remaining_time = 0

func insert_weapon(weapon: Shootable):
	_pending_weapon = weapon
	_pending_remaining_time = pickup_keep_time
	
	print("picked up weapon %s" % weapon)
	
	UiEventBus.emit_signal("weapon_pending_added", weapon)

func _reset_pending_weapon():
	_pending_weapon = null
	_pending_remaining_time = 0

func _process(delta):
	if _pending_weapon != null:
		if Input.is_action_just_pressed("replace_weapon"):
			weapon_system.set_weapon(_pending_weapon)
			_reset_pending_weapon()
		elif Input.is_action_just_pressed("discard_weapon"):
			_reset_pending_weapon()
			UiEventBus.emit_signal("weapon_pending_discarded")
	
	if _pending_weapon != null:
		_pending_remaining_time -= delta
		if _pending_remaining_time <= 0:
			_reset_pending_weapon()
			UiEventBus.emit_signal("weapon_pending_lost")
