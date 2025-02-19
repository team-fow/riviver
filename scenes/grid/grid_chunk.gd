class_name GridChunk
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

## Saves tile types to the game file.
func write_to_file() -> void:
	var types: Array[PackedInt32Array]
	
	types.resize(SIZE.x)
	for x: int in SIZE.x:
		types[x].resize(SIZE.y)
		for y: int in SIZE.y:
			types[x][y] = _tiles[x][y].type
	
	Game.file.set_value("chunks", str(chunk_coords), types)


## Loads tile types from the game file.
func read_from_file() -> void:
	if not Game.file.has_section_key("chunks", str(chunk_coords)):
		generate()
		return
	
	var types: Array[PackedInt32Array] = Game.file.get_value("chunks", str(chunk_coords))
	for x: int in SIZE.x:
		for y: int in SIZE.y:
			_tiles[x][y].type = types[x][y]


## Generates the chunk from scratch.
func generate() -> void:
	sends_ticks = false
	
	for x: int in SIZE.x:
		for y: int in SIZE.y:
			_tiles[x][y].type = Tile.Type.GRASS
	
	sends_ticks = true


## Frees tile RIDs. Call just before the chunk is unloaded.
func stop_tile_rendering() -> void:
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
	
	sends_ticks = true


func _to_string() -> String:
	return "Chunk" + str(chunk_coords)
