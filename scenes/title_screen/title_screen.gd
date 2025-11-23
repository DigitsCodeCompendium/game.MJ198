extends Control

@export var game_scene: PackedScene
@export var main_menu: Control
@export var options_menu: Control


# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu.visible = true
	options_menu.visible = false


func _start_game():
	get_tree().change_scene_to_packed(game_scene)

func _open_options_menu():
	main_menu.visible = false
	options_menu.visible = true

func _open_main_menu():
	main_menu.visible = true
	options_menu.visible = false

func _quit():
	get_tree().quit()
