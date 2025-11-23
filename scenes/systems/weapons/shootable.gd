@abstract
extends Resource
class_name Shootable

@export
var weapon_id: int

@abstract
func get_icon() -> Texture2D

@abstract
func fire_weapon(dir: Vector2, weapon_system:WeaponSystem) -> bool

@abstract
func cooldown_weapon(delta: float, weapon_system:WeaponSystem) -> void

@abstract
func init_weapon_state() -> ShootableState
