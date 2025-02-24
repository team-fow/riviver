extends TileBehavior

const RIVERBED_THRESHOLD: float = -0.5

static var noise: FastNoiseLite = preload("res://assets/worldgen_noise.tres")


func clear() -> void:
	var value: float = noise.get_noise_2dv(tile.coords)
	if value < RIVERBED_THRESHOLD:
		tile.type = Tile.Type.RIVERBED
	else:
		tile.type = Tile.Type.WASTELAND if randf() < 0.995 else Tile.Type.DEAD_TREE
