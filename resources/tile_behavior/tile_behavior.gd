class_name TileBehavior
## Handles custom tile behavior logic.

var tile: Tile ## The tile this behavior is attached to.
var is_tick_queued: bool ## Whether a tick has already been queued for this tile.



# event

## Called when attached to a tile.
func start() -> void:
	pass


## Called when the tile is ticked.
func tick() -> void:
	pass


## Called when the behavior is about to be unattached (i.e. the tile changes type).
func stop() -> void:
	pass


## Called when the tile recieves mouse input.
func input(event: InputEventMouseButton) -> void:
	pass



# helper

# Returns true if some tile is one of some types.
func _tile_matches(tile: Tile, filter: PackedInt32Array) -> bool:
	return tile.type in filter


# Returns true if the tile is surrounded by tiles of some types.
func _is_surrounded_by(filter: PackedInt32Array) -> bool:
	return tile.get_neighbors().all(_tile_matches.bind(filter))


# Calls a callable on tiles outward in a radius.
func _radiate_effect(target: Tile, filter: PackedInt32Array, callable: Callable, radius_squared: float) -> void:
	await Game.grid.get_tree().create_timer(0.05).timeout
	for neighbor: Tile in target.get_neighbors():
		if _tile_matches(neighbor, filter) and neighbor.coords.distance_squared_to(tile.coords) < radius_squared:
			callable.call(neighbor)
			_radiate_effect(neighbor, filter, callable, radius_squared)



# virtual

func _init(tile: Tile) -> void:
	self.tile = tile
