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
	if not DirAccess.dir_exists_absolute(save_path): create_save()
	# world
	file.set_value("grid", "camera_pos", camera.position)
	for chunk: Chunk in grid.get_loaded_chunks():
		chunk.save()
	# materials
	for i: int in Player.MaterialType.size():
		var key: String = Player.MaterialType.keys()[i].to_lower()
		file.set_value("materials", key, Game.player.count_material(i))
		file.set_value("materials", "max_" + key, Game.player.count_max_material(i))
	# clock
	file.set_value("clock", "time", clock.time)
	# saving
	file.save(save_path + "save.ini")


## Reads and restores the game state from disk.
static func read() -> void:
	if not DirAccess.dir_exists_absolute(save_path): create_save()
	# loading
	file.clear()
	file.load(save_path + "save.ini")
	# world
	camera.position = file.get_value("grid", "camera_pos", camera.position)
	# materials
	for i: int in Player.MaterialType.size():
		var key: String = Player.MaterialType.keys()[i].to_lower()
		Game.player.add_material(i, file.get_value("materials", key, 0))
		Game.player.add_max_material(i, file.get_value("materials", "max_" + key, 0))
	# clock
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
