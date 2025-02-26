extends Node
## Stores info resources for easy access.

var tiles: Array[TileInfo]
var cards: Array[CardInfo]


## Returns a card with some name.
func get_card(card_name: String) -> CardInfo:
	card_name = card_name.to_lower()
	for card: CardInfo in cards:
		if card.name.to_lower() == card_name:
			return card
	return null


# Loads all resources inside a folder into an array. Includes subfolders.
func _load_dir_resources(path: String, array: Array) -> void:
	for dir: String in DirAccess.get_directories_at(path):
		_load_dir_resources(path.path_join(dir), array)
	for file: String in DirAccess.get_files_at(path):
		if file.ends_with(".tres"):
			array.append(load(path.path_join(file)))



# virtual

func _ready() -> void:
	for key: String in Tile.Type.keys():
		tiles.append(load("res://resources/tile_info/%s.tres" % key.to_lower()))
	_load_dir_resources("res://resources/card_info/", cards)
