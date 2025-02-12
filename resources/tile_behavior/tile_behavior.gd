class_name TileBehavior

var tile: Tile
var is_tick_queued: bool


func tick() -> void:
	pass



# virtual

func _init(tile: Tile) -> void:
	self.tile = tile
