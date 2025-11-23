extends HBoxContainer

@onready var slider: Slider = get_node("HSlider")
@onready var percentage_label: Label = get_node("Percentage")
@onready var left_button: Button = get_node("LeftButton")
@onready var right_button: Button = get_node("RightButton")
@export var bus_name: String
@export var option_name: String
@export var default_volume_percent: int = 100
var _bus_index

@export var arrow_hold_delay: float = 1
@export var arrow_hold_interval: float = 0.05

var _next_left_time = null
var _next_right_time = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_bus_index = AudioServer.get_bus_index(bus_name)
	var volume_percent = PlayerOptions.get_option(option_name, default_volume_percent)
	AudioServer.set_bus_volume_linear(_bus_index, volume_percent / 100.0)
	slider.value = volume_percent
	percentage_label.text = str(roundi(volume_percent)) + "%"

func _on_slider_value_changed(value: float):
	PlayerOptions.set_option(option_name, value, false)
	AudioServer.set_bus_volume_linear(_bus_index, value / 100.0)
	percentage_label.text = str(roundi(value)) + "%"

func _on_slider_drag_ended(_changed):
	PlayerOptions.save()

func _change_volume_percent(delta: int):
	var percent = roundi(AudioServer.get_bus_volume_linear(_bus_index) * 100)
	percent = clampi(percent + delta, 0, 100)
	PlayerOptions.set_option(option_name, percent, false)
	AudioServer.set_bus_volume_linear(_bus_index, percent / 100.0)
	slider.value = percent
	percentage_label.text = str(percent) + "%"

func _on_left_button_down():
	_change_volume_percent(-1)
	_next_left_time = arrow_hold_delay

func _on_right_button_down():
	_change_volume_percent(1)
	_next_right_time = arrow_hold_delay

func _on_left_button_up():
	_next_left_time = null
	PlayerOptions.save()

func _on_right_button_up():
	_next_right_time = null
	PlayerOptions.save()

func _process(delta):
	if _next_left_time != null:
		_next_left_time -= delta
		while _next_left_time <= 0:
			_next_left_time += arrow_hold_interval
			_change_volume_percent(-1)
	
	if _next_right_time != null:
		_next_right_time -= delta
		while _next_right_time <= 0:
			_next_right_time += arrow_hold_interval
			_change_volume_percent(1)
