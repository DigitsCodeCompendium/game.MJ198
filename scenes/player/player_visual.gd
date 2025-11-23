extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_weapon_style(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_engine_style(style:int) -> void:
	var animation: String
	match style:
		0: animation = "classic"
		1: animation = "spike"
		2: animation = "vintage"
		3: animation = "short"
	$EngineSprite.play(animation)

func set_weapon_style(style:int) -> void:
	var animation: String
	match style:
		0: animation = "none"
		1: animation = "cannon"
		2: animation = "railgun"
		3: animation = "laser"
		4: animation = "shotgun"
		5: animation = "kinetic_rockets"
		6: animation = "he_rockets"
		7: animation = "frag_rockets"
	$WeaponSprite.play(animation)

func set_body_style(style:int) -> void:
	var animation: String
	match style:
		0: animation = "classic"
	$ShipSprite.play(animation)
