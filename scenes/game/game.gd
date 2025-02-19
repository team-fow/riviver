class_name Game
extends Node2D
## Manages helper objects and savefiles.

static var file := ConfigFile.new() ## Player savefile.
static var config := ConfigFile.new() ## Settings savefile.

static var grid: Grid ## Manages tiles.
static var river: River ## Manages the river state.
static var player: Player ## Manages player cards & materials.
static var tick_timer: Timer ## Coordinates ticks.


## Writes the current game state to file.
static func write() -> void:
	for chunk: GridChunk in grid.get_loaded_chunks():
		chunk.write_to_file()
	file.save("user://save.ini")


## Reads and restores the game state from a file.
static func read() -> void:
	file.load("res://default_save.ini")
	file.load("user://save.ini")



# virtual

func _enter_tree() -> void:
	read()


func _ready() -> void:
	# setting shorthand variables
	grid = $Grid
	river = $River
	player = $Player
	tick_timer = $TickTimer
