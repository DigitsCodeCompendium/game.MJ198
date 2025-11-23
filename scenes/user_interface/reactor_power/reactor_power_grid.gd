extends GridContainer

@export var max_power_label: Control
@export var power_pip_scene: PackedScene
@export var lost_power_texture: Texture2D
@export var used_power_texture: Texture2D
@export var free_power_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	UiEventBus.connect("reactor_updated", _on_power_changed)

func _on_power_changed(power_system: PowerSystem):
	for child in get_children():
		child.queue_free()
	
	if power_system.current_max_power % 2 == 1: # Grid layout only does top to bottom, so pad it out with an invisible pip
		var filler: TextureRect = power_pip_scene.instantiate()
		filler.texture = free_power_texture
		filler.modulate = Color(1, 1, 1, 0)
		add_child(filler)
	for i in range(power_system.current_power_loss):
		var power_loss_rect: TextureRect = power_pip_scene.instantiate()
		power_loss_rect.texture = lost_power_texture
		add_child(power_loss_rect)
	for i in range(power_system.passive_power_use + power_system.active_power_use):
		var power_used_rect: TextureRect = power_pip_scene.instantiate()
		power_used_rect.texture = used_power_texture
		add_child(power_used_rect)
	for i in range(power_system.free_power):
		var power_free_rect: TextureRect = power_pip_scene.instantiate()
		power_free_rect.texture = free_power_texture
		add_child(power_free_rect)
	
	max_power_label.visible = power_system.is_max_power_at_limit
