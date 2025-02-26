extends TileBehavior


func tick() -> void:
	if tile.get_neighbors().all(Tile.has_tag.bind("forest")):
		tile.type = Tile.Type.THICKET
