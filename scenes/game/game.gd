class_name Game
extends Node2D
## Manages helper objects and savefiles.

static var file := ConfigFile.new() ## Player savefile.
static var config := ConfigFile.new() ## Settings savefile.
static var save_path: String = "user://save/" ## Path where data should be saved.

static var grid: Grid ## Manages tiles.
static var river: River ## Manages the river state.
static var player: Player ## Manages player cards & materials.
static var clock: Clock ## Manages time & weather.
static var camera: Camera2D ## Manages chunk loading.


## Writes the current game state to disk.
static func write() -> void:
	if not DirAccess.dir_exists_absolute(save_path):
		create_save()
	
	file.set_value("main", "camera_pos", camera.position)
	file.set_value("main", "materials", player.materials)
	file.set_value("main", "time", clock.time)
	
	for chunk: GridChunk in grid.get_loaded_chunks():
		chunk.write_to_file()
	
	file.save(save_path + "save.ini")


## Reads and restores the game state from disk.
static func read() -> void:
	if not DirAccess.dir_exists_absolute(save_path):
		create_save()
	
	file.clear()
	file.load(save_path + "save.ini")
	
	camera.position = file.get_value("main", "camera_pos", camera.position)
	player.materials = file.get_value("main", "materials", player.materials)
	clock.time = file.get_value("main", "time", clock.time)


## Creates a new save.
static func create_save() -> void:
	if not DirAccess.dir_exists_absolute(save_path):
		DirAccess.make_dir_recursive_absolute(save_path)
	
	var default_dir: String = "res://resources/default_save/"
	for filename: String in DirAccess.get_files_at(default_dir):
		DirAccess.copy_absolute(default_dir + filename, save_path + filename)


## Deletes the current save.
static func delete_save() -> void:
	OS.move_to_trash(ProjectSettings.globalize_path(save_path))



# virtual

func _ready() -> void:
	# setting shorthand variables
	grid = $Grid
	river = $River
	player = $Player
	clock = $Clock
	camera = $Camera
	# loading save
	read()
