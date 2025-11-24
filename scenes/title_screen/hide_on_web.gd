extends Button


func _ready():
	visible = not OS.has_feature("web")
