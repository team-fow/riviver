extends TileBehavior


func tick() -> void:
	if not tile.get_neighbors().all(Tile.has_tag.bind("river")):
		tile.type = Tile.Type.SHALLOW_WATER
