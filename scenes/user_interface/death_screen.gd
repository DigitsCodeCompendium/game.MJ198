extends Control

@export_file var main_menu_scene: String
@export_file var game_scene: String

@export var death_animation: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	UiEventBus.connect("player_died", _on_player_died)

func _on_player_died():
	visible = true
	get_tree().paused = true
	
	death_animation.play()
	await death_animation.animation_finished
	$PanelContainer/DeathMenuContainer.visible = true
	$PanelContainer/AnimationContainer.visible = false

func _restart_game():
	get_tree().paused = false
	get_tree().change_scene_to_packed(load(game_scene))

func _goto_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_packed(load(main_menu_scene))

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		death_animation.speed_scale = 10
