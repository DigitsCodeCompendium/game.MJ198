extends Node
class_name PowerSystem

@export var _base_max_power: int = 5
var _current_max_power: int
var _current_power_loss: int # Power lost because of environmental influences

var _passive_power_use: int
var _active_power_use: int

var current_max_power: int:
	get:
		return _current_max_power
	set(value):
		assert(value >= _current_max_power)
		_current_max_power = value
		_dirty = true
		
var current_power_loss: int:
	get:
		return _current_power_loss
	set(value):
		_current_power_loss = value
		_check_power_loss()
		_dirty = true

var effective_max_power: int:
	get:
		return max(_current_max_power - _current_power_loss, 0)

var passive_power_use: int:
	get:
		return _passive_power_use

var active_power_use: int:
	get:
		return _active_power_use

var free_power: int:
	get:
		return effective_max_power - passive_power_use - active_power_use

var _dirty: bool

signal power_changed(power_system: PowerSystem)

# Power consumers need to have:
# is_passive_consumer() -> bool
# getter for current_power
# reduce_power(amount) -> int
var _power_consumers: Array

var power_consumers: Array:
	set(value):
		_power_consumers = value
		_update_power_use()
		_check_power_loss()
		_dirty = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_current_max_power = _base_max_power
	_current_power_loss = 0
	_passive_power_use = 0
	_active_power_use = 0
	_power_consumers = []
	_dirty = false

func request_power(consumer, delta: int) -> bool:
	assert(_power_consumers.find(consumer) >= 0, "Must be a registered consumer")
	
	if free_power >= delta:
		if consumer.is_passive_consumer():
			_passive_power_use += delta
		else:
			_active_power_use += delta
		_dirty = true
		return true
	else:
		return false


func _update_power_use():
	_passive_power_use = 0
	_active_power_use = 0
	
	for consumer in _power_consumers:
		if consumer.is_passive_consumer():
			_passive_power_use += consumer.current_power
		else:
			_active_power_use += consumer.current_power


func _check_power_loss():
	var i = len(_power_consumers) - 1
	while free_power < 0:
		assert(i >= 0) # Something's wrong if we turned off everything but still have insufficient power
		var last_consumer = _power_consumers[i]
		if last_consumer == null:
			continue
		if last_consumer.current_power <= 0:
			i -= 1
			continue
		
		var reduce_power_request = min(-free_power, last_consumer.current_power)
		var reduce_power_result = last_consumer.reduce_power(reduce_power_request)
		if last_consumer.is_passive_consumer():
			_passive_power_use -= reduce_power_result
		else:
			_active_power_use -= reduce_power_result
		
		# Move on to the next upgrade
		i -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _dirty:
		power_changed.emit(self)
		_dirty = false
