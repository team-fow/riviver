class_name WorldtreeTileBehavior
extends TileBehavior

var clear_radius: int


func start() -> void:
	if tile.get_neighbors().any(Tile.is_type.bind([Tile.Type.SMOG])):
		trigger()


func trigger() -> void:
	# loading chunks
	for x: int in range(-clear_radius, clear_radius + 1):
		for y: int in range(-clear_radius, clear_radius + 1):
			var chunk_coords: Vector2i = Grid.get_chunk_coords(tile.coords + Vector2i(x, y))
			if not Game.grid.is_chunk_loaded(chunk_coords): Game.grid.load_chunk(chunk_coords)
	# clearing smog
	Game.grid.radiate_effect(tile, _clear_smog, Tile.is_type.bind([Tile.Type.SMOG]), clear_radius ** 2)


func _clear_smog(target: Tile) -> void:
	target.behavior.clear()
