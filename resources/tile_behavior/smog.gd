extends TileBehavior

@export var type_below: Tile.Type


func clear() -> void:
	tile.type = type_below
