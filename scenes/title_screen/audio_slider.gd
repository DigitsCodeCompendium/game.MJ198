extends HBoxContainer

@onready var slider: Slider = get_node("HSlider")
@onready var percentage_label: Label = get_node("Percentage")
@export var bus_name: String
var _bus_index


# Called when the node enters the scene tree for the first time.
func _ready():
	_bus_index = AudioServer.get_bus_index(bus_name)
	var percentage = AudioServer.get_bus_volume_linear(_bus_index) * 100
	slider.value = percentage
	percentage_label.text = str(roundi(percentage)) + "%"
	
	slider.connect("value_changed", _on_slider_value_changed)

func _on_slider_value_changed(value: float):
	AudioServer.set_bus_volume_linear(_bus_index, value / 100.0)
	percentage_label.text = str(roundi(value)) + "%"
