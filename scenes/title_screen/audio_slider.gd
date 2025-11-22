extends HBoxContainer

@onready var slider: Slider = get_node("HSlider")
@onready var percentage_label: Label = get_node("Percentage")
@onready var left_button: Button = get_node("LeftButton")
@onready var right_button: Button = get_node("RightButton")
@export var bus_name: String
var _bus_index

@export var arrow_hold_delay: float = 1
@export var arrow_hold_interval: float = 0.05

var _next_left_time = null
var _next_right_time = null


# Called when the node enters the scene tree for the first time.
func _ready():
	_bus_index = AudioServer.get_bus_index(bus_name)
	var percentage = AudioServer.get_bus_volume_linear(_bus_index) * 100
	slider.value = percentage
	percentage_label.text = str(roundi(percentage)) + "%"

func _on_slider_value_changed(value: float):
	AudioServer.set_bus_volume_linear(_bus_index, value / 100.0)
	percentage_label.text = str(roundi(value)) + "%"

func _change_volume_percent(delta: int):
	var percent = roundi(AudioServer.get_bus_volume_linear(_bus_index) * 100)
	percent = clampi(percent + delta, 0, 100)
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

func _on_right_button_up():
	_next_right_time = null

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
