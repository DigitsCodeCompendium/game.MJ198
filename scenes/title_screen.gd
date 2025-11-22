extends Control

@export var game_scene: PackedScene
@export var main_menu: Control
@export var options_menu: Control


# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu.visible = true
	options_menu.visible = false


func _on_start_game_pressed():
	var game = get_tree().change_scene_to_packed(game_scene)
