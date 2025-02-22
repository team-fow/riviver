extends TileBehavior


func tick() -> void:
	tile.type = Tile.Type.ASH
	
	for neighbor: Tile in tile.get_neighbors():
		if neighbor.get_info().flammable:
			neighbor.type = Tile.Type.FIRE
