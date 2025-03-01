class_name RiverTileBehavior
extends TileBehavior


func start() -> void:
	Game.river.track_tile(tile)


func stop() -> void:
	Game.river.untrack_tile(tile)
