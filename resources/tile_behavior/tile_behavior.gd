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

func _is_surrounded_by(types: Array[Tile.Type]) -> bool:
	return tile.get_neighbors().all(_tile_matches.bind(types))


func _tile_matches(tile: Tile, types: Array[Tile.Type]) -> bool:
	return tile.type in types



# virtual

func _init(tile: Tile) -> void:
	self.tile = tile
