extends Node

signal reactor_updated(max_power:int, free_power:int)
signal module_updated(slot:int, module:BaseModule)
signal module_pending_added(module: BaseModule)
signal module_pending_lost()
signal module_pending_discarded()
signal weapon_updated(weapon)
signal engine_updated(engine)
