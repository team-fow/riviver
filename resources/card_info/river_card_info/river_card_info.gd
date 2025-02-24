class_name RiverCardInfo
extends "res://resources/card_info/card_info.gd"


@export var targets_water: bool ## Whether the card targets a water tile (and thus is sedimentation) or not (and thus is erosion)
@export var radius: float

var water_tiles: Array[Tile.Type] = [Tile.Type.RIVER, Tile.Type.SHALLOW_WATER, Tile.Type.DEEP_WATER]
var not_erodible: Array[Tile.Type] = [Tile.Type.RIVER, Tile.Type.SHALLOW_WATER, Tile.Type.DEEP_WATER, Tile.Type.YGGDRASIL, Tile.Type.YGGDRASIL_SAPLING, Tile.Type.LIBRARY]


# Plays the card, converting the targetted tile into a tile of the result type
func play(target: Tile):
	var erodibletiles = erodible_tiles()
	if not targets_water:
		target.radiate_effect(Tile.set_type.bind(Tile.Type.RIVERBED), radius**2, erodibletiles, true)
	else:
		target.radiate_effect(Tile.set_type.bind(Tile.Type.DIRT), radius**2, water_tiles, true)


# Generates an array of all the types of tile that can be eroded
func erodible_tiles():
	var all_tiles = Tile.Type.values()
	for tiletype in not_erodible:
		all_tiles.erase(tiletype)
	return all_tiles


# Determines whether the card can be played on a certain tile and returns a bool
func can_be_played(target: Tile) -> bool:
	if targets_water:
		if target.type in water_tiles:
			return true
		else:
			return false
	else:
		if target.type in erodible_tiles():
			var neighbors_water = target.get_neighbors().filter(func(t): return t.type in water_tiles)
			if neighbors_water.size() > 0:
				return true
			else:
				return false
		else:
			return false
