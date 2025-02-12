extends TileBehavior


func tick() -> void:
	for neighbor: Tile in tile.get_neighbors():
		if neighbor.type == Tile.Type.DIRT:
			neighbor.type = Tile.Type.GRASS
