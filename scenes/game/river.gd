class_name River
extends Node
## Manages the river state.

var tiles: Array[Tile] ## Tiles part of the river. Should only contain river tiles.
var cleanliness: float ## Average water cleanliness. Ranges from 0 to 1.

var fish: int ## Number of fish in the river.



# cleanliness

## Starts tracking a tile as part of the river. Only use with river tiles.
func track_tile(tile: Tile) -> void:
	tiles.append(tile)
	_adjust_cleanliness(_get_cleanliness(tile), tiles.size() - 1)


## Stops tracking a tile.
func untrack_tile(tile: Tile) -> void:
	assert(tile in tiles)
	tiles.erase(tile)
	_adjust_cleanliness(-_get_cleanliness(tile), tiles.size() + 1)


# Adjusts cleanliness by adding a value to the raw score and then reaveraging it over the tile count.
func _adjust_cleanliness(value: float, old_size: int) -> void:
	cleanliness = (cleanliness * old_size + value) / tiles.size()


# Returns a tile's cleanliness.
func _get_cleanliness(tile: Tile) -> float:
	return 1.0 - float(tile.behavior.grime) / tile.behavior.MAX_GRIME
