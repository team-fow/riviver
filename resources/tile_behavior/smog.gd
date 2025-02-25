extends TileBehavior


func clear() -> void:
	tile.type = WorldGen.get_tile_type(tile.coords)
