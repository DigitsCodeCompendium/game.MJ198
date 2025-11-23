extends Area2D

@export var speed = 300
@export var y_pos = 0.2 #as a percentage of the screen size (bottom up)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	connect("area_entered", _on_player_collide)
	
	# set default pos on the screen on startup
	var screen_size = get_viewport().size
	position.y = screen_size.y * (1 - y_pos)
	position.x = screen_size.x/2
	
	set_engine_style(PlayerOptions.get_option("customize_engine", 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("shoot"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	var velocity = Vector2(0, 0)
	var mouse_pos = get_viewport().get_mouse_position()
	var difference = mouse_pos - position
	var max_speed = difference.length()
	
	velocity = (difference.normalized()*speed*delta)
	velocity = velocity.limit_length(max_speed)
	
	if Input.mouse_mode == Input.MOUSE_MODE_CONFINED:
		position += velocity
	var margins = get_parent().playable_margins
	#Clamp player to the screen
	position.x = clamp(position.x,margins,get_viewport().size.x-margins)
	position.y = clamp(position.y,0,get_viewport().size.y)
	
func _on_player_collide(area: Area2D):
	if area.is_in_group("enemy"):
		print("AAAAHHHHH")

func set_engine_style(style:int) -> void:
	$PlayerVisual.set_engine_style(style)

func set_weapon_style(style:int) -> void:
	$PlayerVisual.set_weapon_style(style)

func set_body_style(style:int) -> void:
	$PlayerVisual.set_body_style(style)
