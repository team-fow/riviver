extends HarvesterTileBehavior


func harvest() -> void:
	Game.grid.get_tiles_in_radius(tile, Tile.is_type.bind([Tile.Type.WHEAT_FIELD]), 2)
