extends Control

@onready var weapon_icon = get_node("%Weapon")
@onready var engine_icon = get_node("%Engine")
@onready var free_power_bar = get_node("%ReactorPower")
@onready var speed_label = get_node("%SpeedLabel")
@onready var speed_bar = get_node("%SpeedProgressBar")
@onready var pending_module = get_node("%PickedUpModule")
@onready var pending_module_timer = get_node("%ModuleTimer")
@onready var pending_module_bar = get_node("%ModuleDiscardProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEventBus.connect("reactor_updated",_on_power_changed)
	UiEventBus.connect("current_speed",_on_speed_update)
	UiEventBus.connect("module_pending_added",_on_module_added)
	UiEventBus.connect("module_pending_lost",_on_module_lost)
	UiEventBus.connect("module_pending_discarded",_on_module_lost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not pending_module_timer.is_stopped():
		pending_module_bar.value = pending_module_timer.get_time_left()
		

func _on_power_changed(curent_max_power:int,free_power:int):
	free_power_bar.value = free_power
	
func _on_speed_update(speed_str:String):
	speed_label.text = speed_str
	speed_bar.value = int(float(speed_str)*100)

func _on_module_added(module:BaseModule):
	pending_module.visible = true
	pending_module_timer.start(5)
	
	
func _on_module_lost():
	pending_module.visible = false
	pending_module_timer.stop()
