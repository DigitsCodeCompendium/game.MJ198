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
	var mouse_pos = get_viewport().get_mouse_position()
	var difference = mouse_pos - position
	var max_speed = difference.length()
	
	velocity = (difference.normalized()*speed*delta)
	velocity = velocity.limit_length(max_speed)
		
	position += velocity
	

func _on_player_collide(area: Area2D):
	if area.is_in_group("enemy"):
		print("AAAAHHHHH")
