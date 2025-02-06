class_name Tile
extends Node2D
## A single tile in the [Grid].[br]
## To add new tiles, add an entry in [enum Type] and create a [TileInfo] in the [code]tile_info[/code] folder with the same name.

enum Type {
	EMPTY = -1,
	GRASS,
	DIRT,
	ASH,
}

static var info: Array[TileInfo] ## Data for each tile type.

var type: Type ## Numerical type ID.
var coords: Vector2i : set = _set_coords ## The tile's coordinates in the grid.
var prop: Prop ## The [Prop] on this tile.

var _tick_queued: bool # Whether a tick has already been queued. See [method queue_tick].

@onready var _sprite: Sprite2D = $Sprite


## Returns a new [Tile] scene of [param type].
static func of(type: Type) -> Tile:
	var tile: Tile = info[type].scene.instantiate()
	tile.type = type
	return tile



# ticking

## Called whenever the tile is ticked. Overwrite this method to add custom behavior. To queue a tick, see [method queue_tick].
func _tick() -> void:
	pass


## Queues a tick. See [method _tick].
func queue_tick() -> void:
	if _tick_queued: return
	_tick_queued = true
	await Game.tick_timer.timeout
	_tick_queued = false
	
	_tick()
	if prop: prop._tick()



# coords

## Returns a list of the six adjacent tiles. Nonexistent tiles are omitted.
func get_neighbors() -> Array[Tile]:
	var neighbors: Array[Tile]
	for coords: Vector2i in Game.grid.get_adjacent_coords(coords):
		var neighbor: Tile = Game.grid.get_tile(coords)
		if neighbor: neighbors.append(neighbor)
	return neighbors


# Updates [member position] to match [member coords].
func _set_coords(value: Vector2i) -> void:
	coords = value
	position = Game.grid.coords_to_point(coords)



# props

## Sets [member prop] to a new [Prop] of [param type].[br]
## [param type] should not be [enum Prop.Type.EMPTY]. Use [method remove_prop] instead.
func set_prop(type: Prop.Type) -> void:
	assert(type != Prop.Type.EMPTY)
	if prop: remove_prop()
	prop = Prop.of(type)
	prop.tile = self
	add_child(prop)
	queue_tick()


## Removes the [Prop] on this tile.
func remove_prop() -> void:
	assert(prop)
	prop.queue_free()
	prop = null



# info

# Populates [member info] with a [TileInfo] resource for each [enum Tile.Type].
static func _static_init() -> void:
	info.assign(Type.keys().slice(1).map(func(key: String) -> TileInfo: return load("res://resources/tile_info/%s.tres" % key.to_lower())))
	info.make_read_only()
