extends Area2D

@export var speed = 300
@export var y_pos = 0.2 #as a percentage of the screen size (bottom up)

@onready var sfx_module_pickup: AudioStreamPlayer = $SoundEffects/SFX_ModulePickup
@onready var sfx_weapon_pickup: AudioStreamPlayer = $SoundEffects/SFX_WeaponPickup

@export var weapon_system: WeaponSystem
@export var module_system: ModuleSystem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	connect("area_entered", _on_player_collide)
	UiEventBus.connect("module_pending_added",_on_module_picked_up)
	UiEventBus.connect("weapon_pending_added",_on_weapon_picked_up)
	
	# set default pos on the screen on startup
	var screen_size = get_viewport().size
	position.y = screen_size.y * (1 - y_pos)
	position.x = screen_size.x/2
	
	set_engine_style(PlayerOptions.get_option("customize_engine", 0))
	
	weapon_system.connect("weapon_switched", _on_weapon_switched)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("escape"):
	#	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#elif Input.is_action_just_pressed("shoot"):
	#	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	var velocity = Vector2(0, 0)
	var mouse_pos = get_viewport().get_mouse_position()
	var difference = mouse_pos - position
	var max_speed = difference.length()
	
	var speed_mod = 1
	speed_mod += module_system.get_module_property("ship_mobility")
	
	velocity = (difference.normalized()*speed*delta*speed_mod)
	velocity = velocity.limit_length(max_speed)
	
	#if Input.mouse_mode == Input.MOUSE_MODE_CONFINED:
	position += velocity
	var margins = get_parent().playable_margins
	#Clamp player to the screen
	position.x = clamp(position.x,margins,get_viewport().size.x-margins)
	position.y = clamp(position.y,0,get_viewport().size.y)
	
func _on_player_collide(area: Area2D):
	if area.is_in_group("enemy") or area.is_in_group("enemy_projectile"):
		get_tree().paused = true
		UiEventBus.emit_signal("player_died")
		$AnimationPlayer.play("death")
		
		var music_player: AudioStreamPlayer = get_node("/root/Game/MusicPlayer")
		var tween = music_player.create_tween()
		tween.tween_property(music_player, "volume_linear", 0, 1.5)
		await tween.finished
		music_player.stop()

func set_engine_style(style:int) -> void:
	$PlayerVisual.set_engine_style(style)

func set_weapon_style(style:int) -> void:
	$PlayerVisual.set_weapon_style(style)

func set_body_style(style:int) -> void:
	$PlayerVisual.set_body_style(style)

func _on_module_picked_up(_module: BaseModule):
	sfx_module_pickup.play()
	
func _on_weapon_picked_up(_weapon: Shootable):
	sfx_module_pickup.play()

func _on_weapon_switched(_weapon_system:WeaponSystem) -> void:
	set_weapon_style(weapon_system.current_weapon.weapon_id)
