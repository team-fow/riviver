extends Node
## Stores info resources for easy access.

var _tiles: Array[TileInfo]


func get_tile(type: Tile.Type) -> TileInfo:
	return _tiles[type]


func get_tiles() -> Array[TileInfo]:
	return _tiles


func get_card(key: String) -> CardInfo:
	return $Cards.get_resource(key)


func get_cards() -> Array[CardInfo]:
	var cards: Array[CardInfo]
	for key: String in $Cards.get_resource_list():
		cards.append($Cards.get_resource(key))
	return cards


func _ready() -> void:
	_load_info("tile_info", Tile.Type.keys(), _tiles)


func _load_info(folder: String, filenames: PackedStringArray, target_array: Array) -> void:
	var path: String = "res://resources/%s/" % folder
	for filename: String in filenames:
		target_array.append(load(path + filename.to_lower() + ".tres"))
	target_array.make_read_only()
