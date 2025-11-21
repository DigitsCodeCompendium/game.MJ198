extends Node2D

# can probably add some kind of hash table to prestore upgrades in groups of their groups,
# but this works for now
var upgrades = []

func add_upgrade(upgrade: BaseUpgrade):
	upgrades.append(upgrade)

func get_upgrades(group: String) -> Array:
	var rlist = []
	for upgrade in upgrades:
		if upgrade.is_in_group(group):
			rlist.append(upgrade)
	return rlist
