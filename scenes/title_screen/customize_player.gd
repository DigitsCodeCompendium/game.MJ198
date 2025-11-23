extends HBoxContainer

@export var select_engine_button: OptionButton
@export var player_visual: Node2D


func _ready():
	var engine_index: int = PlayerOptions.get_option("customize_engine", 0)
	select_engine_button.selected = engine_index
	player_visual.set_engine_style(engine_index)

func _on_select_engine(index: int):
	PlayerOptions.set_option("customize_engine", index)
	player_visual.set_engine_style(index)
