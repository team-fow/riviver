class_name BuildingTileBehavior
extends TileBehavior


func start() -> void:
	Game.town_manager.track_tile(tile)


func stop() -> void:
	Game.town_manager.untrack_tile(tile)
