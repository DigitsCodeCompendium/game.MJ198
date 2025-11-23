extends Node2D

@export
var scrolling_backgrounds: Array[Parallax2D]

var scroll_speed: float = 1

func set_scroll_speed(speed:float):
	scroll_speed = speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for background in scrolling_backgrounds:
		background.scroll_offset.y += scroll_speed * background.scroll_scale.y
