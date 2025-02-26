extends TileBehavior


func tick() -> void:
	tile.type = Tile.Type.ASH
	
	var neighbors: Array[Tile] = tile.get_neighbors().filter(Tile.has_tag.bind("flammable"))
	if neighbors:
		for i: int in randi_range(1, 2):
			neighbors.pick_random().type = Tile.Type.FIRE
