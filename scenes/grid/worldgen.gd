class_name WorldGen

static var noise: FastNoiseLite = preload("res://assets/worldgen_noise.tres")


static func get_tile_type(coords: Vector2i) -> Tile.Type:
	var value: float = noise.get_noise_2dv(coords)
	
	if value < -0.45 and value > -0.55:
		return Tile.Type.RIVERBED
	else:
		return Tile.Type.WASTELAND if randf() < 0.995 else Tile.Type.DEAD_TREE
