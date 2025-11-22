extends PanelContainer

@onready var power_bar = get_node("%EnergyProgressBar")
@onready var upgrade_bar = get_node("%UpgradeProgressBar")
@onready var power_up_button = get_node("%IncreasePower")
@onready var power_down_button = get_node("%DecreasePower")
@onready var mod_icon = get_node("%ModuleSprite")
@onready var installed_module = get_node("%FilledModule")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func update_module(mod:BaseModule) -> void:
	if mod == null:
		installed_module.visible = false
	else:
		installed_module.visible = true
		power_bar.value = mod.current_power
		upgrade_bar.value = mod.upgrade_progress
		#mod_icon.texture = mod.
