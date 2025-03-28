class_name WaterMinigame
extends Minigame

@onready var grid: PipeGrid = $Grid
@onready var pipes: PipeHolder = $Pipes

@export var start_point: Vector2i # The grid coordinates at which the water flow starts
@export var end_point: Vector2i # The grid coordinates that the player is trying to reach
@export var grid_def: Dictionary[Vector2i, String] # The dictionary that stores data about what is on the grid
@export var pipe_def: Dictionary[String, int] # The dictionary that stores data about the pipes the player has access to

var held_pipe: Pipe # The pipe currently held, if any


func start() -> void:
	super()
	for p:String in pipe_def.keys():
		for i:int in pipe_def[p]:
			var new_pipe: Pipe = load("res://Scenes/minigames/water_minigame/pipes/pipe.tscn").instantiate()
			new_pipe.holes = Pipe.string_to_directions(p)
			pipes.add_pipe(new_pipe)
			new_pipe.grabbed.connect(func(): held_pipe = new_pipe)
			new_pipe.dropped.connect(func(): drop_pipe(new_pipe))
			

# Redraw the grid
func redraw() -> void:
	for child in grid.get_children():
		if child is Sprite2D:
			child.queue_free()
	for coords in grid_def.keys():
		grid.place_on_grid(coords, get_texture(grid_def[coords]))


# Converts a string from grid_def to its appropriate texture
func get_texture(s: String) -> Texture2D:
	return load("res://icon.svg")


# Handles when a pipe is dropped
func drop_pipe(dropped_pipe: Pipe) -> void:
	if not grid.pipe_hovered:
		dropped_pipe.position = Vector2.ZERO # Replace with a more robust "add to hand" function
	else:
		var local_coords: Vector2 = grid.to_local(get_global_mouse_position())
		var grid_coords: Vector2i = grid.position_to_coords(local_coords)
		if grid_def.get(grid_coords) == null:
			grid_def.get_or_add(grid_coords, Pipe.directions_to_string(dropped_pipe.holes))
			pipes.remove_child(dropped_pipe)
			pipes.pipes.erase(dropped_pipe)
			pipes.order_pipes()
			redraw()
		else:
			dropped_pipe.position = Vector2.ZERO # Replace with a more robust "add to hand" function
		

# Run the water and check if it flows properly
func check_water() -> bool:
	var curr_coords: Vector2i = start_point
	var connecting_from: Pipe.DIRECTIONS = Pipe.DIRECTIONS.UP
	var curr_contents = grid_def.get(curr_coords)
	while curr_contents != null:
		print(curr_contents + " at " + str(curr_coords))
		if curr_contents == "ROCK": return false
		else:
			var pipe_dir : Array[Pipe.DIRECTIONS] = Pipe.string_to_directions(curr_contents)
			if not pipe_dir.has(connecting_from): return false
			else:
				pipe_dir.erase(connecting_from)
				connecting_from = Pipe.flip_direction(pipe_dir[0])
				if curr_coords == end_point and connecting_from == Pipe.DIRECTIONS.UP: return true
				else:
					curr_coords = Pipe.dir_to_vector(pipe_dir[0]) + curr_coords
					curr_contents = grid_def.get(curr_coords)
	return false
	
	
func _on_run_water_pressed() -> void:
	if check_water():
		modulate = Color.GREEN
		await get_tree().create_timer(0.5).timeout
		ended.emit(self, 1.0)
	else:
		modulate = Color.RED
		await get_tree().create_timer(0.5).timeout
		ended.emit(self, 0.0)


func _on_pause_pressed() -> void:
	set_paused(true)
