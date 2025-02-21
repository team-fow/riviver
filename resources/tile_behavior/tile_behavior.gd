class_name TileBehavior
## Handles custom tile behavior logic.

var tile: Tile ## The tile this behavior is attached to.
var is_tick_queued: bool ## Whether a tick has already been queued for this tile.


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



# virtual

func _init(tile: Tile) -> void:
	self.tile = tile
