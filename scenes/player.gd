extends Area2D

@export var speed = 300
@export var y_pos = 0.2 #as a percentage of the screen size (bottom up)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", _on_player_collide)
	
	# set default pos on the screen on startup
	var screen_size = get_viewport_rect().size
	position.y = screen_size.y * (1 - y_pos)
	position.x = screen_size.x/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2(0, 0)
	if Input.is_action_pressed("move_left"):
		velocity.x = -1 * speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = 1 * speed
	else:
		var mouse_pos = get_viewport().get_mouse_position()
		var difference = mouse_pos - position
		
		velocity = (difference.normalized()*speed*delta)
		var max_speed = difference.length()
		
		velocity = velocity.limit_length(max_speed)/delta
		
	position += velocity * delta
	

func _on_player_collide(area: Area2D):
	if area.is_in_group("enemy"):
		print("AAAAHHHHH")
