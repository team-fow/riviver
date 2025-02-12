class_name GridChunk
extends Resource
## Handles local tile editing and serialization.

const SIZE := Vector2i(16, 32) ## Size, in tiles.

@export var _tiles: Array[Array] # Tile matrix of size SIZE.

var chunk_coords: Vector2i ## Chunk coordinates.
var tile_offset: Vector2i ## Coords of the top-leftmost tile.
var is_generated: bool ## Whether the chunk has been generated


## Adds a tile. Frees the existent tile at the same coords, if any.
func set_tile(coords: Vector2i, type: Tile.Type) -> void:
	_tiles[coords.x - tile_offset.x][coords.y - tile_offset.y].type = type


## Returns the tile at some coords, or null if no tile exists.
func get_tile(coords: Vector2i) -> Tile:
	coords -= tile_offset
	return _tiles[coords.x][coords.y] if _tiles[coords.x] else null


## Controls whether the chunk is rendered.
func set_visible(visible: bool) -> void:
	for x: int in SIZE.x:
		for y: int in SIZE.y:
			_tiles[x][y].set_visible(visible)


## Generates the chunk from scratch.
func generate() -> void:
	is_generated = false
	
	_tiles.resize(SIZE.x)
	for x: int in SIZE.x:
		_tiles[x].resize(SIZE.y)
		for y: int in SIZE.y:
			_tiles[x][y] = Tile.new(Tile.Type.GRASS, tile_offset + Vector2i(x, y))
	
	is_generated = true



# virtual

func _init(chunk_coords: Vector2i) -> void:
	self.chunk_coords = chunk_coords
	tile_offset = chunk_coords * SIZE
