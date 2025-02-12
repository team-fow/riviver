extends Node
## Stores info resources for easy access.

var tiles: Array[TileInfo]


func _ready() -> void:
	_load_info("tile_info", Tile.Type.keys().slice(1), tiles)


func _load_info(folder: String, filenames: PackedStringArray, target_array: Array) -> void:
	var path: String = "res://resources/%s/" % folder
	for filename: String in filenames:
		target_array.append(load(path + filename.to_lower() + ".tres"))
	target_array.make_read_only()
