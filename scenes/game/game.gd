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
