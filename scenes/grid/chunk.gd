class_name Chunk
## Handles local tile editing and serialization.

const SIZE := Vector2i(16, 32) ## Size, in tiles.

var _tiles: Array[Array] # Tile matrix of size SIZE.

var chunk_coords: Vector2i ## Chunk coordinates.
var tile_offset: Vector2i ## Coords of the top-leftmost tile.

var sends_ticks: bool ## Whether this chunk's tiles send ticks.



# tiles

## Adds a tile. Frees the existent tile at the same coords, if any.
func set_tile(coords: Vector2i, type: Tile.Type) -> void:
	_tiles[coords.x - tile_offset.x][coords.y - tile_offset.y].type = type


## Returns the tile at some coords, or null if no tile exists.
func get_tile(coords: Vector2i) -> Tile:
	coords -= tile_offset
	return _tiles[coords.x][coords.y] if _tiles[coords.x] else null



# loading & unloading

## Saves tile types to a file.
func save() -> void:
	var file: FileAccess = FileAccess.open(Game.save_path + str(chunk_coords), FileAccess.WRITE_READ)
	var types := PackedInt32Array()
	types.resize(SIZE.x + SIZE.y * SIZE.x)
	
	for x: int in SIZE.x:
		for y: int in SIZE.y:
			types[x + y * SIZE.x] = _tiles[x][y].type
	
	file.store_buffer(types.to_byte_array())
	file.close()


## Loads tile types from a file.
func load() -> void:
	var types: PackedInt32Array = FileAccess.get_file_as_bytes(Game.save_path + str(chunk_coords)).to_int32_array()
	
	if types:
		sends_ticks = false
		for x: int in SIZE.x:
			for y: int in SIZE.y:
				_tiles[x][y].type = types[x + y * SIZE.x]
		sends_ticks = true
	
	else:
		sends_ticks = false
		for x: int in SIZE.x:
			for y: int in SIZE.y:
				_tiles[x][y].type = Tile.Type.SMOG
		sends_ticks = true


## Saves the chunk and stops rendering.
func unload() -> void:
	save()
	for x: int in SIZE.x:
		for y: int in SIZE.y:
			_tiles[x][y].stop_rendering()



# virtual

func _init(chunk_coords: Vector2i) -> void:
	self.chunk_coords = chunk_coords
	tile_offset = chunk_coords * SIZE
	
	# setting up matrix
	sends_ticks = false
	
	_tiles.resize(SIZE.x)
	for x: int in SIZE.x:
		_tiles[x].resize(SIZE.y)
		for y: int in SIZE.y:
			_tiles[x][y] = Tile.new(tile_offset + Vector2i(x, y))
			_tiles[x][y].chunk = self
	
	sends_ticks = true


func _to_string() -> String:
	return "Chunk" + str(chunk_coords)
