extends TileBehavior


func tick() -> void:
	tile.type = Tile.Type.ASH
	
	var neighbors: Array[Tile] = tile.get_neighbors().filter(_is_tile_flammable)
	if neighbors:
		for i: int in randi_range(1, 2):
			neighbors.pick_random().type = Tile.Type.FIRE


func _is_tile_flammable(tile: Tile) -> bool:
	return tile.get_info().flammable
