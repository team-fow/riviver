class_name YggdrasilTileBehavior
extends TileBehavior

var clear_radius: int


func start() -> void:
	var neighbors: Array[Tile] = tile.get_neighbors()
	
	if neighbors.any(func(tile: Tile) -> bool: return tile.type == Tile.Type.SMOG):
		
		for x: int in range(-clear_radius, clear_radius + 1):
			for y: int in range(-clear_radius, clear_radius + 1):
				var chunk_coords: Vector2i = Grid.get_chunk_coords(tile.coords + Vector2i(x, y))
				if not Game.grid.is_chunk_loaded(chunk_coords): Game.grid.load_chunk(chunk_coords)
		
		var clear_radius_squared: int = clear_radius ** 2
		for neighbor: Tile in neighbors:
			_clear_smog(neighbor, clear_radius_squared)


func _clear_smog(smog: Tile, max_distance: int) -> void:
	if smog.type != Tile.Type.SMOG or smog.coords.distance_squared_to(tile.coords) > max_distance: return
	
	smog.behavior.clear()
	
	await Game.grid.get_tree().create_timer(0.05).timeout
	for neighbor: Tile in smog.get_neighbors():
		_clear_smog(neighbor, max_distance)
