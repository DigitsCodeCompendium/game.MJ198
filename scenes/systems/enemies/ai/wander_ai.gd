extends Node

@onready var player: Node2D = get_node("/root/Game/Player")

@export var death_sources: Array[Node]
@export var area: Area2D

@export var speed: float = 100
@export var pos_threshold: float = 40

var _brain_dead: bool = false
var _target_pos: Vector2 = Vector2.ZERO

func _new_random_target():
	var x_size = get_viewport().size.x
	var y_size = get_viewport().size.y
	_target_pos = Vector2(randf_range(0, x_size), randf_range(0, y_size))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for death_source in death_sources:
		death_source.connect("on_death", _on_death)
	_new_random_target()

func _on_death():
	_brain_dead = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _brain_dead:
		var velocity = (_target_pos - area.owner.position).normalized() * speed
		area.owner.position += velocity * delta
		area.rotation = velocity.angle() + PI/2
		
		if (area.owner.position - _target_pos).length() < pos_threshold:
			_new_random_target()
