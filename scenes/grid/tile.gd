class_name Tile
## A tile on the grid.

enum Type {
	NONE,
	SMOG,
	WORLDTREE,
	WORLDTREE_SAPLING,
	LIBRARY,
	GRASS,
	DIRT,
	ASH,
	FIRE,
	HOUSE,
	GRASS_LAND,
	FOREST,
	THICKET,
	WASTELAND,
	DEAD_TREE,
	RIVERBED,
	ROCKS,
	SHALLOW_WATER,
	DIRT_ROAD,
	DEEP_WATER,
	FERTILE_SOIL,
	TALLGRASS,
	WHEAT_FIELD,
	FARMHOUSE,
	BEEHIVE,
	LILYPAD,
	STUMP,
	PAVED_ROAD,
	WINDMILL,
	HOLLOW_TREE,
	
}

const SIZE := Vector2(24, 16) ## Size, in pixels.

var type: Type : set = _set_type ## Type ID. Affects the tile's rendering and behavior.
var behavior: TileBehavior ## Recieves ticks and runs tick logic.

var coords: Vector2i : set = _set_coords ## The tile's grid coordinates.
var chunk: Chunk ## The chunk this tile is in.

var rid: RID = RenderingServer.canvas_item_create() ## A canvas item ID. Used for rendering.
var transform: Transform2D ## The transform applied to this tile.



# coords

# Sets coords and updates position to match.
func _set_coords(value: Vector2i) -> void:
	coords = value
	chunk = Game.grid.get_chunk(Grid.get_chunk_coords(coords))
	set_position(Grid.coords_to_point(coords))


## Returns the six adjacent tiles. Omits nonexistent tiles.
func get_neighbors() -> Array[Tile]:
	var neighbors: Array[Tile]
	for coords: Vector2i in Grid.get_adjacent_coords(coords):
		var tile: Tile = Game.grid.get_tile(coords)
		if tile: neighbors.append(tile)
	return neighbors



# type

# Ticks and redraws when type is changed.
func _set_type(value: Type) -> void:
	if type == value: return
	type = value
	_redraw()
	# behavior
	if behavior:
		behavior.stop()
		behavior = null
	if get_info().behavior:
		behavior = get_info().behavior.new(self)
		behavior.start()
	# ticking
	if chunk and chunk.sends_ticks:
		Game.grid.queue_tick_with_neighbors(self)


## Returns an info resource for the tile.
func get_info() -> TileInfo:
	return ResourceLibrary.tiles[type]



# ticking

## Queues a tick. Tick behavior is controlled by the tile's behavior object.
func queue_tick() -> void:
	var behavior: TileBehavior = behavior
	if not behavior or behavior.is_tick_queued: return
	behavior.is_tick_queued = true
	await Game.grid.tick_timer.timeout
	behavior.is_tick_queued = false
	behavior.tick()



# rendering

# Redraws the tile based on the current tile type.
func _redraw() -> void:
	var info: TileInfo = get_info()
	RenderingServer.canvas_item_clear(rid)
	RenderingServer.canvas_item_set_material(rid, info.sprite_material.get_rid() if info.sprite_material else RID())
	RenderingServer.canvas_item_set_z_index(rid, info.sprite_z_index)
	
	var sheet_coords: Vector2i
	
	match info.sprite_sheet.sheet_picking:
		SpriteSheet.Picking.RANDOMIZE:
			sheet_coords = info.sprite_sheet.pick_random()
		
		SpriteSheet.Picking.CONNECT_BOUNDARY:
			var directions: Array[Grid.Direction] = get_neighbors().filter(Tile.is_type.bind([type])).slice(0, 2).map(func(tile: Tile) -> int:
				return Vector2(coords).angle_to_point(tile.coords) / TAU * 6
			)
			sheet_coords = info.sprite_sheet.pick_connected_boundary(directions.front(), directions.back())
	
	info.sprite_sheet.draw(rid, sheet_coords)


## Sets where the tile is rendered.
func set_position(position: Vector2) -> void:
	transform.origin = position
	RenderingServer.canvas_item_set_transform(rid, transform)


## Sets whether the tile is rendered.
func set_visible(visible: bool) -> void:
	RenderingServer.canvas_item_set_visible(rid, visible)


## Frees the tile's RID. Call just before the tile is unloaded.
func stop_rendering() -> void:
	RenderingServer.free_rid(rid)



# input

func input(event: InputEventMouseButton) -> void:
	if behavior: behavior.input(event)



# helper

## Returns true if some tile's type is in some filter.
static func is_type(tile: Tile, types: PackedInt32Array) -> bool:
	return tile.type in types


## Returns true if a tile has some tag.
static func has_tag(tile: Tile, tag: String) -> bool:
	return tag in tile.get_info().tags


## Sets some tile's type.
static func set_type(tile: Tile, type: Type) -> void:
	tile.type = type


## Converts some wasteland tile into some greenery tile.
static func revitalize(tile: Tile) -> void:
	match tile.type:
		Tile.Type.WASTELAND: tile.type = Tile.Type.GRASS
		Tile.Type.RIVERBED: tile.type = Tile.Type.SHALLOW_WATER
		Tile.Type.DEAD_TREE: tile.type = Tile.Type.FOREST



# virtual

func _init(coords: Vector2i) -> void:
	self.coords = coords
	RenderingServer.canvas_item_set_parent(rid, Game.grid.get_canvas_item())


func _to_string() -> String:
	return get_info().name + str(coords)
