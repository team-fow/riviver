extends TileBehavior


func tick() -> void:
	tile.type = Tile.Type.ASH
	
	for neighbor: Tile in tile.get_neighbors():
		if neighbor.type == Tile.Type.GRASS:
			neighbor.type = Tile.Type.FIRE
