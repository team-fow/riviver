class_name Tile
## A tile on the grid.

enum Type {
	NONE,
	SMOG,
	YGGDRASIL,
	YGGDRASIL_SAPLING,
	LIBRARY,
	GRASS,
	DIRT,
	ASH,
	FIRE,
	RIVER,
	HOUSE,
	GRASS_LAND,
	FOREST,
	THICKET,
	WASTELAND,
	DEAD_TREE,
	RIVERBED,
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
	RenderingServer.canvas_item_set_material(rid, info.material.get_rid() if info.material else RID())
	RenderingServer.canvas_item_set_z_index(rid, info.z_index)
	info.sprite_sheet.draw(rid)


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
static func matches(tile: Tile, filter: PackedInt32Array) -> bool:
	return tile.type in filter


## Converts some wasteland tile into some greenery tile.
static func revitalize(tile: Tile) -> void:
	match tile.type:
		Tile.Type.WASTELAND: tile.type = Tile.Type.GRASS
		Tile.Type.RIVERBED: tile.type = Tile.Type.RIVER


## Calls a callable on tiles outward in some radius.
func radiate_effect(callable: Callable, radius_squared: float, filter: PackedInt32Array, target: Tile = self) -> void:
	await Game.grid.get_tree().create_timer(0.05).timeout
	for neighbor: Tile in target.get_neighbors():
		if matches(neighbor, filter) and neighbor.coords.distance_squared_to(coords) < radius_squared:
			callable.call(neighbor)
			radiate_effect(callable, radius_squared, filter, neighbor)



# virtual

func _init(coords: Vector2i) -> void:
	self.coords = coords
	RenderingServer.canvas_item_set_parent(rid, Game.grid.get_canvas_item())


func _to_string() -> String:
	return get_info().name + str(coords)
