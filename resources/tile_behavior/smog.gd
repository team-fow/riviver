extends TileBehavior

const RIVERBED_THRESHOLD: float = -0.5

static var noise: FastNoiseLite = preload("res://assets/worldgen_noise.tres")


func clear() -> void:
	tile.type = WorldGen.get_tile_type(tile.coords)
