extends Node2D

@export var scrolling_backgrounds: Array[Parallax2D]
@onready var speed_control = get_parent().get_node("SpeedControl")
var scroll_speed = Vector2()

func set_scroll_speed(speed:float):
	scroll_speed = speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scroll_speed.y = speed_control.relativistic_speed * 250
	$Parallax2D2.autoscroll = scroll_speed
	pass
