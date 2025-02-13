class_name Game
extends Node2D
## Manages the game state.

static var grid: Grid ## Manages tiles.
static var tick_timer: Timer ## Coordinates ticks.



# virtual

func _ready() -> void:
	# setting shorthand variables
	grid = $Grid
	tick_timer = $TickTimer
	
	# macdonough demo
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	grid.set_tile(Vector2i(-1, -1), Tile.Type.ASH)
	grid.set_tile(Vector2i(0, 0), Tile.Type.ASH)
	grid.set_tile(Vector2i(0, 1), Tile.Type.ASH)
	grid.set_tile(Vector2i(1, 2), Tile.Type.ASH)
	grid.set_tile(Vector2i(1, 0), Tile.Type.ASH)
	grid.set_tile(Vector2i(1, -2), Tile.Type.ASH)
	grid.set_tile(Vector2i(1, -1), Tile.Type.ASH)
	grid.set_tile(Vector2i(2, 0), Tile.Type.ASH)
	grid.set_tile(Vector2i(2, 1), Tile.Type.ASH)
	
	grid.set_tile(Vector2i(2, -3), Tile.Type.ASH)
	grid.set_tile(Vector2i(3, -2), Tile.Type.ASH)
	grid.set_tile(Vector2i(3, -1), Tile.Type.ASH)
	grid.set_tile(Vector2i(4, 0), Tile.Type.ASH)
	
	grid.set_tile(Vector2i(4, -4), Tile.Type.ASH)
	grid.set_tile(Vector2i(4, -3), Tile.Type.ASH)
	grid.set_tile(Vector2i(5, -1), Tile.Type.ASH)
