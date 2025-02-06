class_name Grid
extends Node2D
## Manager for all [Tile] nodes.

var _tiles: Array[Tile] # List of tiles on the grid, sorted by coordinates. See [method _sort_tiles].
var _map: TileMapLayer # Only used for coordinates.



# modifying

## Sets the [Tile] at [param coords] in [param layer] to a new [Tile] of [param type].[br]
## [param type] should not be [enum Tile.Type.EMPTY]. Use [method remove_tile] instead.
func set_tile(type: Tile.Type, coords: Vector2i) -> Tile:
	assert(type != Tile.Type.EMPTY)
	var new_tile: Tile = Tile.of(type)
	new_tile.coords = coords
	
	# inserting into list, removing old tile if any
	var idx: int = _get_tile_idx(new_tile)
	if idx < _tiles.size() and _tiles[idx].coords == new_tile.coords:
		_tiles[idx].queue_free()
		_tiles[idx] = new_tile
	else:
		_tiles.insert(idx, new_tile)
	
	# adding to tree
	add_child(new_tile)
	_queue_tick_neighborhood(new_tile)
	return new_tile


## Removes [param tile] from the grid and frees it.
func remove_tile(tile: Tile) -> void:
	assert(tile in _tiles)
	_tiles.remove_at(_get_tile_idx(tile))
	tile.queue_free()


## Returns the [Tile] at [param coords] in [param layer].
func get_tile(coords: Vector2i) -> Tile:
	var tile := Tile.new()
	tile.coords = coords
	var idx: int = _get_tile_idx(tile)
	if idx < _tiles.size() and _tiles[idx].coords == coords:
		return _tiles[idx]
	return null



# ticking

# Ticks [param tile] and its neighboring tiles. See [method Tile.get_neighbors].
func _queue_tick_neighborhood(tile: Tile) -> void:
	tile.queue_tick()
	for neighbor: Tile in tile.get_neighbors():
		neighbor.queue_tick()



# coords

## Converts a position to grid coordinates.
func point_to_coords(point: Vector2) -> Vector2i:
	return _map.local_to_map(point)


## Converts grid coordinates to a position.
func coords_to_point(coords: Vector2i) -> Vector2:
	return _map.map_to_local(coords)


## Returns the six coordinates adjacent to [param coords].
func get_adjacent_coords(coords: Vector2i) -> Array[Vector2i]:
	return _map.get_surrounding_cells(coords)



# sorting

# Returns the index of [param tile] in [member _tiles]. If [param tile] is not in [member _tiles], returns the index [param tile] would need to be inserted at to keep the list sorted.
func _get_tile_idx(tile: Tile) -> int:
	return _tiles.bsearch_custom(tile, _sort_tiles)


# Sorting function for [member _tiles].
func _sort_tiles(a: Tile, b: Tile) -> bool:
	return a.coords < b.coords



# internal

func _ready() -> void:
	# readying map for use
	_map = TileMapLayer.new()
	_map.tile_set = TileSet.new()
	_map.tile_set.tile_shape = TileSet.TILE_SHAPE_HEXAGON
	_map.tile_set.tile_size = Vector2i(24, 16)
