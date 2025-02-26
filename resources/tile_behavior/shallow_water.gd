extends TileBehavior


func tick() -> void:
	if tile.get_neighbors().all(Tile.has_tag.bind("river")):
		tile.type = Tile.Type.DEEP_WATER
