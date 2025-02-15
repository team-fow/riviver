class_name Tile
## A tile on the grid.

enum Type {
	NONE = -1,
	GRASS,
	DIRT,
	ASH,
	FIRE,
}

const SIZE := Vector2(24, 16) ## Size, in pixels.
const CLIFF_COLOR_1 := Color("#867b74")
const CLIFF_COLOR_2 := Color("#705d5b")

var type: Type = Type.NONE : set = _set_type ## Type ID. Affects the tile's rendering and behavior.
var behavior: TileBehavior ## Recieves ticks and runs tick logic.

var coords: Vector2i : set = _set_coords ## The tile's grid coordinates.
var elevation: int : set = _set_elevation ## The tile's elevation. Applied as a vertical offset. Can't go below 0.

var rid: RID = RenderingServer.canvas_item_create() ## A canvas item ID. Used for rendering.
var transform: Transform2D ## The transform applied to this tile.



# coords

# Sets coords and updates position to match.
func _set_coords(value: Vector2i) -> void:
	coords = value
	set_position(Grid.coords_to_point(coords))


# Sets elevation and redraws.
func _set_elevation(value: int) -> void:
	elevation = max(value, 0)
	_redraw()


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
	behavior = get_info().behavior.new(self) if get_info().behavior else null
	_redraw()
	# ticking
	var chunk: GridChunk = Game.grid.get_chunk(Grid.get_chunk_coords(coords))
	if chunk and chunk.sends_ticks:
		Game.grid.queue_tick_with_neighbors(self)


## Returns an info resource for the tile.
func get_info() -> TileInfo:
	return Library.tiles[type]



# ticking

## Queues a tick. Tick behavior is controlled by the tile's behavior object.
func queue_tick() -> void:
	var behavior: TileBehavior = behavior
	if not behavior or behavior.is_tick_queued: return
	behavior.is_tick_queued = true
	await Game.tick_timer.timeout
	behavior.is_tick_queued = false
	behavior.tick()



# rendering

func _redraw() -> void:
	RenderingServer.canvas_item_clear(rid)
	RenderingServer.canvas_item_set_parent(rid, Game.grid.get_canvas_item())
	
	if get_info().material:
		RenderingServer.canvas_item_set_material(rid, get_info().material.get_rid())
	
	if elevation:
		var cliff_rect := Rect2(-12, 12 - elevation, 12, 12 + elevation)
		RenderingServer.canvas_item_add_rect(rid, cliff_rect, CLIFF_COLOR_1)
		cliff_rect.position.x += 12
		RenderingServer.canvas_item_add_rect(rid, cliff_rect, CLIFF_COLOR_2)
	
	_draw_sprite(get_info())


# Draws a sprite.
func _draw_sprite(info: TileInfo) -> void:
	var target_rect := Rect2(-info.sprite_size/2, info.sprite_size)
	var src_rect := Rect2(Vector2.ZERO, info.sprite_size)
	
	target_rect.position.y = -elevation
	
	match info.sprite_sheet_picking:
		TileInfo.SpriteSheetPicking.RANDOMIZE:
			src_rect.position.x = randi() % info.sprite_sheet_size.x * info.sprite_size.x
			src_rect.position.y = randi() % info.sprite_sheet_size.y * info.sprite_size.y
	
	RenderingServer.canvas_item_add_texture_rect_region(rid, target_rect, info.sprite_sheet, src_rect)


## Sets where the tile is rendered.
func set_position(position: Vector2) -> void:
	transform.origin = position
	RenderingServer.canvas_item_set_transform(rid, transform)


## Sets whether the tile is rendered.
func set_visible(visible: bool) -> void:
	RenderingServer.canvas_item_set_visible(rid, visible)



# destructor

## Frees the tile's RID. Call just before the tile is unloaded.
func stop_rendering() -> void:
	RenderingServer.free_rid(rid)



# virtual

func _init(type: Type, coords: Vector2i) -> void:
	self.coords = coords
	self.type = type


func _to_string() -> String:
	return get_info().name + str(coords)
