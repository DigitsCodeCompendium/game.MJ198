extends Control

@onready var weapon_sprite = get_node("%WeaponSprite")
@onready var engine_sprite = get_node("%EngineSprite")

@onready var speed_label = get_node("%SpeedLabel")
@onready var speed_bar = get_node("%SpeedProgressBar")

@onready var pending_module = get_node("%PickedUpModule")
@onready var pending_module_timer = get_node("%ModuleTimer")
@onready var pending_module_bar = get_node("%ModuleDiscardProgressBar")
@onready var pending_module_sprite = get_node("%PendingModuleSprite")

@onready var pending_wep_eng = get_node("%PickedUpEngWep")
@onready var pending_wep_eng_timer = get_node("%EngWepTimer")
@onready var pending_wep_eng_bar = get_node("%EngWepDiscardProgressBar")
@onready var pending_wep_eng_sprite = get_node("%PendingWepEngSprite")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	UiEventBus.connect("current_speed",_on_speed_update)
	
	UiEventBus.connect("module_pending_added",_on_module_added)
	UiEventBus.connect("module_pending_applied",_on_module_applied)
	UiEventBus.connect("module_pending_lost",_on_module_lost)
	UiEventBus.connect("module_pending_discarded",_on_module_lost)
	
	UiEventBus.connect("weapon_pending_added",_on_weapon_added)
	UiEventBus.connect("weapon_pending_applied",_on_weapon_applied)
	UiEventBus.connect("weapon_pending_discarded",_on_weapon_lost)
	UiEventBus.connect("weapon_pending_lost",_on_weapon_lost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not pending_module_timer.is_stopped():
		pending_module_bar.value = pending_module_timer.get_time_left()
	
	if not pending_wep_eng_timer.is_stopped():
		pending_wep_eng_bar.value = pending_wep_eng_timer.get_time_left()
	
func _on_speed_update(speed_str:String):
	speed_label.text = speed_str
	speed_bar.value = int(float(speed_str)*100)

func _on_module_added(module:BaseModule):
	pending_module_sprite.texture = module.module_icon
	pending_module.visible = true
	pending_module_timer.start(5)

func _on_module_applied(_slot: int, _module: BaseModule):
	pending_module.visible = false
	pending_module_timer.stop()
	
func _on_module_lost():
	pending_module.visible = false
	pending_module_timer.stop()

func _on_weapon_added(weapon: Shootable):
	pending_wep_eng_sprite.texture = weapon.weapon_icon
	pending_wep_eng.visible = true
	pending_wep_eng_timer.start(5)
	
func _on_weapon_applied(weapon: Shootable):
	weapon_sprite.texture = weapon.weapon_icon
	pending_wep_eng.visible = false
	pending_wep_eng_timer.stop()
	
func _on_weapon_lost():
	pending_wep_eng.visible = false
	pending_wep_eng_timer.stop()
