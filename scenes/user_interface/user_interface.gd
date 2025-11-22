extends Control

@onready var weapon_icon = get_node("%Weapon")
@onready var engine_icon = get_node("%Engine")
@onready var free_power_bar = get_node("%ReactorPower")
@onready var speed_label = get_node("%SpeedLabel")
@onready var speed_bar = get_node("%SpeedProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiEventBus.connect("reactor_updated",_on_power_changed)
	UiEventBus.connect("current_speed",_on_speed_update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_power_changed(curent_max_power:int,free_power:int):
	free_power_bar.value = free_power
	
func _on_speed_update(speed_str:String):
	speed_label.text = speed_str
	speed_bar.value = int(float(speed_str)*100)
