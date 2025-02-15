class_name Game
extends Node2D
## Manages the game state.

static var save_idx: int
static var file := ConfigFile.new() ## Player savefile.
static var config := ConfigFile.new() ## Settings.

static var grid: Grid ## Manages tiles.
static var tick_timer: Timer ## Coordinates ticks.



# virtual

func _ready() -> void:
	# setting shorthand variables
	grid = $Grid
	tick_timer = $TickTimer


func _exit_tree() -> void:
	file.save("user://save.ini")
