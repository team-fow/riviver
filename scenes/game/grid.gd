class_name Grid
extends Node2D
## Manages tiles.

static var _map: TileMapLayer # Used for coordinate math.

var _chunks: Dictionary # Loaded chunks.



# tiles

## Adds a tile. Frees the existent tile at the same coords, if any.
func set_tile(coords: Vector2i, type: Tile.Type) -> void:
	var chunk: GridChunk = get_chunk(get_chunk_coords(coords))
	if chunk: chunk.set_tile(coords, type)


## Returns the tile at some coords. Returns null if the tile is unloaded.
func get_tile(coords: Vector2i) -> Tile:
	var chunk: GridChunk = get_chunk(get_chunk_coords(coords))
	return chunk.get_tile(coords) if chunk else null



# chunks

## Returns the chunk at some chunk coords.
func get_chunk(chunk_coords: Vector2i) -> GridChunk:
	return _chunks[chunk_coords] if is_chunk_loaded(chunk_coords) else null


## Loads the chunk at some chunk coords.
func load_chunk(chunk_coords: Vector2i) -> void:
	_chunks[chunk_coords] = GridChunk.new(chunk_coords)
	_chunks[chunk_coords].generate()


## Loads the chunk at some chunk coords.
func unload_chunk(chunk_coords: Vector2i) -> void:
	_chunks.erase(chunk_coords)


## Returns true whether the chunk at some chunk coords is loaded.
func is_chunk_loaded(chunk_coords: Vector2i) -> bool:
	return chunk_coords in _chunks


## Returns a list of loaded chunks.
func get_loaded_chunks() -> Array:
	return _chunks.values()


## Returns the chunk coords for some coords.
static func get_chunk_coords(coords: Vector2i) -> Vector2i:
	var chunk_coords: Vector2 = coords
	chunk_coords.x /= GridChunk.SIZE.x
	chunk_coords.y /= GridChunk.SIZE.y
	return chunk_coords.floor()



# ticks

## Queues a tick for some tile and its neighboring tiles.
func queue_tick_with_neighbors(tile: Tile) -> void:
	tile.queue_tick()
	for coords: Vector2i in get_adjacent_coords(tile.coords):
		var neighbor: Tile = get_tile(coords)
		if neighbor: neighbor.queue_tick()



# coords

## Converts a position to coords.
static func point_to_coords(point: Vector2) -> Vector2i:
	return _map.local_to_map(point)


## Converts coords to a position.
static func coords_to_point(coords: Vector2i) -> Vector2:
	return _map.map_to_local(coords)


## Returns the six coords adjacent to some coords.
static func get_adjacent_coords(coords: Vector2i) -> Array[Vector2i]:
	return _map.get_surrounding_cells(coords)



# virtual

static func _static_init() -> void:
	# readying map for use
	_map = TileMapLayer.new()
	_map.tile_set = TileSet.new()
	_map.tile_set.tile_shape = TileSet.TILE_SHAPE_HEXAGON
	_map.tile_set.tile_size = Tile.SIZE
