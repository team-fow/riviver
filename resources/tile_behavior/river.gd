extends TileBehavior

const MAX_GRIME: int = 3 ## Maximum grime value.

var grime: int : set = _set_grime ## Water dirtiness. Clamped from 0 to MAX_GRIME.

var _water_rid: RID = RenderingServer.canvas_item_create() ## Used for rendering water.
var _water_sprite_sheet: SpriteSheet = preload("res://resources/sprite_sheet/water.tres") ## Used for drawing water.
var _grime_gradient: Gradient = preload("res://assets/grime_gradient.tres") ## Sampled when modulating water color.


func start() -> void:
	RenderingServer.canvas_item_set_parent(_water_rid, tile.rid)
	_water_sprite_sheet.draw(_water_rid)
	grime = randi_range(0, MAX_GRIME)
	Game.river.track_tile(tile)


func stop() -> void:
	Game.river.untrack_tile(tile)
	RenderingServer.free_rid(_water_rid)


# Clamps grime between 0 and MAX_GRIME.
func _set_grime(value: int) -> void:
	grime = clampi(value, 0, MAX_GRIME)
	RenderingServer.canvas_item_set_modulate(_water_rid, Color(_grime_gradient.sample(float(grime) / MAX_GRIME), 0.5))
