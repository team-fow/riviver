class_name YggdrasilTileBehavior
extends TileBehavior

var clear_radius: int


func start() -> void:
	var clear_radius_squared: int = clear_radius ** 2
	for neighbor: Tile in tile.get_neighbors():
		_clear_smog(neighbor, clear_radius_squared)


func _clear_smog(smog: Tile, max_distance: int) -> void:
	if smog.type != Tile.Type.SMOG or smog.coords.distance_squared_to(tile.coords) > max_distance: return
	
	smog.behavior.clear()
	
	await Game.grid.get_tree().create_timer(0.05).timeout
	for neighbor: Tile in smog.get_neighbors():
		_clear_smog(neighbor, max_distance)
