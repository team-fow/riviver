class_name WorldGen

const DENS: Array[Tile.Type] = [
	Tile.Type.BEEHIVE,
	Tile.Type.HOLLOW_TREE,
	Tile.Type.LILYPAD,
]

static var noise: FastNoiseLite = preload("res://assets/worldgen_noise.tres")


static func get_tile_type(coords: Vector2i) -> Tile.Type:
	var value: float = noise.get_noise_2dv(coords)
	
	if value < -0.45 and value > -0.55:
		return Tile.Type.RIVERBED
	elif is_peak(coords):
		return DENS.pick_random()
	else:
		return Tile.Type.WASTELAND if randf() < 0.995 else Tile.Type.DEAD_TREE


static func is_peak(coords: Vector2i) -> bool:
	var value: float = noise.get_noise_2dv(coords)
	for adj_coords: Vector2i in Grid.get_adjacent_coords(coords):
		if value < noise.get_noise_2dv(adj_coords):
			return false
	return true
