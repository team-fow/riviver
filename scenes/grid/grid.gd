class_name Grid
extends Node2D
## Manages tiles.

enum Direction {
	NORTHWEST,
	NORTHEAST,
	WEST,
	EAST,
	SOUTHWEST,
	SOUTHEAST,
}

static var _map: TileMapLayer # Used for coordinate math.

var _chunks: Dictionary # Loaded chunks.

@onready var tick_timer: Timer = $TickTimer ## Coordinates ticks.



# tiles

## Adds a tile. Frees the existent tile at the same coords, if any.
func set_tile(coords: Vector2i, type: Tile.Type) -> void:
	var chunk: Chunk = get_chunk(get_chunk_coords(coords))
	if chunk: chunk.set_tile(coords, type)


## Returns the tile at some coords. Returns null if the tile is unloaded.
func get_tile(coords: Vector2i) -> Tile:
	var chunk: Chunk = get_chunk(get_chunk_coords(coords))
	return chunk.get_tile(coords) if chunk else null



# chunks

## Returns the chunk at some chunk coords.
func get_chunk(chunk_coords: Vector2i) -> Chunk:
	return _chunks[chunk_coords] if is_chunk_loaded(chunk_coords) else null


## Loads the chunk at some chunk coords.
func load_chunk(chunk_coords: Vector2i) -> void:
	_chunks[chunk_coords] = Chunk.new(chunk_coords)
	_chunks[chunk_coords].load()


## Loads the chunk at some chunk coords.
func unload_chunk(chunk_coords: Vector2i) -> void:
	_chunks[chunk_coords].unload()
	_chunks.erase(chunk_coords)


## Returns true if the chunk at some chunk coords is loaded.
func is_chunk_loaded(chunk_coords: Vector2i) -> bool:
	return chunk_coords in _chunks


## Returns a list of loaded chunks.
func get_loaded_chunks() -> Array:
	return _chunks.values()


## Returns the chunk coords for some coords.
static func get_chunk_coords(coords: Vector2i) -> Vector2i:
	var chunk_coords: Vector2 = coords
	chunk_coords.x /= Chunk.SIZE.x
	chunk_coords.y /= Chunk.SIZE.y
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



# helper

## Calls a callable on tiles around a center tile.
func radiate_effect(center: Tile, effect: Callable, filter: Callable, radius_squared: float, affect_center: bool = false, target: Tile = center) -> void:
	if affect_center: effect.call(target)
	await Game.grid.get_tree().create_timer(0.05).timeout
	for neighbor: Tile in target.get_neighbors():
		var distance: float = center.coords.distance_squared_to(neighbor.coords)
		if filter.call(neighbor) and distance < radius_squared and distance > center.coords.distance_squared_to(target.coords):
			effect.call(neighbor)
			radiate_effect(center, effect, filter, radius_squared, false, neighbor)


func get_tiles_in_radius(center: Tile, filter: Callable, radius_squared: float, target: Tile = center) -> Array[Tile]:
	var tiles: Array[Tile]
	for neighbor: Tile in target.get_neighbors():
		if filter.call(neighbor) and center.coords.distance_squared_to(neighbor.coords) < radius_squared:
			tiles.append(neighbor)
			tiles.append_array(get_tiles_in_radius(center, filter, radius_squared, neighbor))
	return tiles


## Returns all contiguous tiles matching a filter.
func get_contiguous_tiles(tile: Tile, filter: Callable) -> Array[Tile]:
	var tiles: Array[Tile] = tile.get_neighbors().filter(filter)
	tiles.append_array(tiles.map(get_contiguous_tiles.bind(filter)))
	return tiles



# virtual

static func _static_init() -> void:
	# readying map for use
	_map = TileMapLayer.new()
	_map.tile_set = TileSet.new()
	_map.tile_set.tile_shape = TileSet.TILE_SHAPE_HEXAGON
	_map.tile_set.tile_size = Tile.SIZE


func _unhandled_input(event: InputEvent) -> void:
	# tile input
	if event is InputEventMouseButton:
		var tile: Tile = get_tile(point_to_coords(get_local_mouse_position()))
		if tile: tile.input(event)
