extends TileBehavior


func tick() -> void:
	if tile.get_neighbors().all(Tile.matches.bind([Tile.Type.FOREST, Tile.Type.THICKET])):
		tile.type = Tile.Type.THICKET
