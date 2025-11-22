extends Node

@export var module_system: ModuleSystem

@export var pickup_keep_time: float = 5
@export var discard_time: float = 0.5

var _pending_module: BaseModule
var _pending_remaining_time: float

# float means how long the player has held the discard button, null means discard button is not held
var _discard_pending_progress # float or null
var _discard_progress: Array # array of float or null

var pending_module: BaseModule:
	get:
		return _pending_module

var pending_remaining_time: float:
	get:
		return _pending_remaining_time

var discard_pending_progress:
	get:
		return _discard_pending_progress

var discard_progress: # Array of 5 float|null values, for each slot
	get:
		return _discard_progress

func _ready():
	_reset_pending_module()
	_reset_discard_progress()

func _reset_pending_module():
	_pending_module = null
	_pending_remaining_time = 0
	_discard_pending_progress = null
	Input.action_release("discard_module_pending")

func _reset_discard_progress():
	_discard_pending_progress = null
	_discard_progress = []
	for i in range(module_system.num_module_slots):
		_discard_progress.append(null)
		Input.action_release("discard_module_%d" % (i+1))

func insert_module(module: BaseModule):
	for module_slot in module_system.module_slots:
		if module_slot.module == module:
			module_slot.add_level_progress(1)
			return

	_pending_module = module
	_pending_remaining_time = pickup_keep_time
	_reset_discard_progress()
	
	print("picked up module %s" % module)

	UiEventBus.emit_signal("module_pending_added", module)
	
func _replace_module(i):
	print("Replacing module at %d with %s" % [i, _pending_module])
	module_system.set_module(i, _pending_module)
	_discard_progress[i] = null
	Input.action_release("discard_module_%d" % (i+1))

func _process(delta):
	var any_discard = false
	for i in range(module_system.num_module_slots):
		var can_discard = module_system.get_module(i) != null || _pending_module != null
		if can_discard and Input.is_action_pressed("discard_module_%d" % (i + 1)):
			_discard_progress[i] = _discard_progress[i] + delta if _discard_progress[i] != null else delta
			if _discard_progress[i] > discard_time:
				_replace_module(i)
				UiEventBus.emit_signal("module_pending_applied", i, _pending_module)
				_reset_pending_module()
			any_discard = true
		else:
			_discard_progress[i] = null
	
	if _pending_module != null:
		if Input.is_action_pressed("discard_module_pending"):
			_discard_pending_progress = _discard_pending_progress + delta if _discard_pending_progress != null else delta
			if _discard_pending_progress > discard_time:
				_reset_pending_module()
				UiEventBus.emit_signal("module_pending_discarded")
		else:
			_discard_pending_progress = null

	if _pending_module != null:
		_pending_remaining_time -= delta
		if _pending_remaining_time <= 0 and not any_discard:
			_reset_pending_module()
			_reset_discard_progress()
			UiEventBus.emit_signal("module_pending_lost")
			
