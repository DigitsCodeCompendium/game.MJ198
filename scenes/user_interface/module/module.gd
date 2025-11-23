extends Control

var empty_sprite = preload("res://assets/module_icons/emptyslot.png")
var backgrounds = [
	preload("res://assets/module_icons/basic_background.png"),
	preload("res://assets/module_icons/advanced_background.png"),
	preload("res://assets/module_icons/master_background.png"),
	preload("res://assets/module_icons/ultimate_background.png")
]

var power_pip_scene: PackedScene = preload("res://scenes/user_interface/module/module_power_pip.tscn")
var upgrade_pip_scene: PackedScene = preload("res://scenes/user_interface/module/module_upgrade_pip.tscn")

var active_min_power_tex: Texture2D = preload("res://assets/module_icons/active_min_power.png")
var empty_min_power_tex: Texture2D = preload("res://assets/module_icons/empty_min_power.png")
var active_extra_power_tex: Texture2D = preload("res://assets/module_icons/active_extra_power.png")
var empty_extra_power_tex: Texture2D = preload("res://assets/module_icons/empty_extra_power.png")

var active_upgrade_tex: Texture2D = preload("res://assets/module_icons/active_upgrade.png")
var empty_upgrade_tex: Texture2D = preload("res://assets/module_icons/empty_upgrade.png")
var blue_upgrade_tex: Texture2D = preload("res://assets/module_icons/blue_upgrade.png")

@onready var power_container = get_node("%EnergyContainer")
@onready var upgrade_container = get_node("%UpgradeContainer")
@onready var power_up_button = get_node("%IncreasePower")
@onready var power_down_button = get_node("%DecreasePower")
@onready var mod_icon = get_node("%ModuleSprite")
@onready var mod_background = get_node("%ModuleBackground")



func set_slot(slot: int):
	var increase_power_binding = InputMap.action_get_events("power_up_module_%d" % (slot + 1))[0]
	var decrease_power_binding = InputMap.action_get_events("power_down_module_%d" % (slot + 1))[0]
	power_up_button.text = increase_power_binding.as_text().substr(0, 1)
	power_down_button.text = decrease_power_binding.as_text().substr(0, 1)

func update_module(mod: ModuleSlot) -> void:
	print("received module update")
	if mod.module == null:
		mod_icon.texture = empty_sprite
		power_container.get_node("MinPower").visible = false
		for i in range(1, power_container.get_child_count()):
			power_container.get_child(i).queue_free()
		for child in upgrade_container.get_children():
			child.free()

	else:
		mod_icon.texture = mod.module.module_icon
		mod_background.texture = backgrounds[mod.current_level]
		
		var min_power_display: TextureRect = power_container.get_node("MinPower")
		
		for i in range(1, power_container.get_child_count()):
			power_container.get_child(i).queue_free()
		
		min_power_display.visible = true
		min_power_display.texture = active_min_power_tex if mod.is_active else empty_min_power_tex
		min_power_display.custom_minimum_size = Vector2(mod.activation_power * 20 - 8, 32)
		
		for i in range(mod.extra_power_limit):
			var pip: TextureRect = power_pip_scene.instantiate()
			if i < mod.current_extra_power:
				pip.texture = active_extra_power_tex
			else:
				pip.texture = empty_extra_power_tex
			power_container.add_child(pip)
			
		for child in upgrade_container.get_children():
			child.queue_free()
		if mod.is_max_level:
			for i in range(mod.upgrade_cost):
				var pip: TextureRect = upgrade_pip_scene.instantiate()
				pip.texture = blue_upgrade_tex
				upgrade_container.add_child(pip)
		else:
			for i in range(mod.upgrade_cost):
				var index = mod.current_level - i
				var pip: TextureRect = upgrade_pip_scene.instantiate()
				if index < mod.upgrade_progress:
					pip.texture = active_upgrade_tex
				else:
					pip.texture = empty_upgrade_tex
				upgrade_container.add_child(pip)
