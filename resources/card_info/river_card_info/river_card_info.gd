class_name RiverCardInfo
extends "res://resources/card_info/card_info.gd"


@export var targets_water: bool ## Whether the card targets a water tile (and thus is sedimentation) or not (and thus is erosion)
@export var radius: float


# Plays the card, converting the targetted tile into a tile of the result type
func play(target: Tile):
	if not targets_water:
		Game.grid.radiate_effect(target, Tile.revitalize, _can_erode, radius ** 2, true)
	else:
		Game.grid.radiate_effect(target, Tile.set_type.bind(Tile.Type.DIRT), Tile.has_tag.bind("river"), radius ** 2, true)


func _can_erode(tile: Tile) -> bool:
	return not (Tile.has_tag(tile, "river") or Tile.has_tag(tile, "unique"))


# Determines whether the card can be played on a certain tile and returns a bool
func can_be_played(target: Tile) -> bool:
	if targets_water:
		return Tile.has_tag(target, "water")
	else:
		return _can_erode(target) and target.get_neighbors().any(Tile.has_tag.bind("water"))
