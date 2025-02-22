extends TileBehavior


func tick() -> void:
	if _is_surrounded_by([Tile.Type.FOREST, Tile.Type.THICKET]):
		tile.type = Tile.Type.THICKET
