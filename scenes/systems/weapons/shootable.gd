@abstract
extends Resource
class_name Shootable

@abstract
func get_icon() -> Texture2D

@abstract
func fire_weapon(dir: Vector2, weapon_system:WeaponSystem, weapon_state:ShootableState) -> bool

@abstract
func cooldown_weapon(delta: float, weapon_state:ShootableState) -> void

@abstract
func init_weapon_state() -> ShootableState
