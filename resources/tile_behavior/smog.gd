extends TileBehavior

@export var type_below: Tile.Type = Tile.Type.GRASS


func clear() -> void:
	tile.type = type_below
