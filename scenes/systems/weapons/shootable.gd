@abstract
extends Resource
class_name Shootable

@abstract
func fire_weapon(weapon_system:WeaponSystem, module_system:ModuleSystem) -> bool

@abstract
func cooldown_weapon(amount: float) -> void
