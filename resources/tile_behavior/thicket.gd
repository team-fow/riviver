extends TileBehavior


func tick() -> void:
	if not tile.get_neighbors().all(Tile.has_tag.bind("forest")):
		tile.type = Tile.Type.FOREST
