extends TileBehavior


func tick() -> void:
	if tile.get_neighbors().all(Tile.matches.bind([Tile.Type.SHALLOW_WATER, Tile.Type.DEEP_WATER])):
		tile.type = Tile.Type.DEEP_WATER
