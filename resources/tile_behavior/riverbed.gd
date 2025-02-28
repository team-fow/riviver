extends TileBehavior


func tick() -> void:
	if tile.get_neighbors().any(Tile.has_tag.bind("river")):
		tile.type = Tile.Type.SHALLOW_WATER
