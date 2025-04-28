class_name WaterMinigame
extends Minigame

@onready var grid: PipeGrid = $Grid
@onready var pipes: PipeHolder = $Pipes
@onready var undo: TextureButton = $Background/Margins/Top/Undo
@onready var filters_needed_label: Label = $Background/Margins/Top/Filters/VBox/Filters

@export var start_point: Vector2i # The grid coordinates at which the water flow starts
@export var end_point: Vector2i # The grid coordinates that the player is trying to reach
@export var filters_needed: Array[String] # The filter types needed
@export var grid_def: Dictionary[Vector2i, String] # The dictionary that stores data about what is on the grid
@export var pipe_def: Dictionary[String, int] # The dictionary that stores data about the pipes the player has access to

var last_placed_at: Array[Vector2i] # The coordinates that the player last placed a pipe at
var held_pipe: Pipe # The pipe currently held, if any


func start() -> void:
	super()
	pipes.minigame = self
	if pipes.h_box_container.get_children().is_empty():
		for p:String in pipe_def.keys():
			for i:int in pipe_def[p]:
				var new_pipe: Pipe = Pipe.create_pipe(p)
				pipes.create_or_add_to_stack(new_pipe)
				new_pipe.grabbed.connect(func(): held_pipe = new_pipe)
				new_pipe.dropped.connect(func(): drop_pipe(new_pipe))
		redraw(true)
	if not Save.get_pointer_done(1) && pipes.get_child(0).get_children().any(func(stack): return stack is PipeStack):
		for i in 2:
			var tutorial_object : PipeStack = pipes.get_child(0).get_children().filter(func(stack): return stack is PipeStack)[0]
			await pointer.tutorial_point(tutorial_object.global_position, grid.grid_collision.global_position)
		Save.set_pointer_done(1)			

# Redraw the grid
func redraw(draw_rocks: bool = false) -> void:
	for child in grid.get_children():
		if child is Sprite2D and child.get_meta("Type") != "ROCK":
			child.queue_free()
	for coords in grid_def.keys():
		if grid_def[coords] != "ROCK" or draw_rocks:
			grid.place_on_grid(coords, get_texture(grid_def[coords]), grid_def[coords])


# Converts a string from grid_def to its appropriate texture
static func get_texture(s: String) -> Texture2D:
	var straight: Texture2D = preload("res://assets/minigames/water/Straight_.png")
	var curve: Texture2D = preload("res://assets/minigames/water/Curve.png")
	var filter: Texture2D = preload("res://assets/minigames/water/Water_filter_.png")
	var rock: Texture2D = preload("res://assets/minigames/water/Obstacles_.png")
	match s:
		"UPDOWN": return straight
		"DOWNLEFT": return curve
		"LEFTRIGHT": 
			var image = straight.get_image()
			image.rotate_90(CLOCKWISE)
			return ImageTexture.create_from_image(image)
		"UPLEFT": 
			var image = curve.get_image()
			image.rotate_90(CLOCKWISE)
			return ImageTexture.create_from_image(image)
		"UPRIGHT": 
			var image = curve.get_image()
			image.rotate_180()
			return ImageTexture.create_from_image(image)
		"DOWNRIGHT": 
			var image = curve.get_image()
			image.rotate_90(COUNTERCLOCKWISE)
			return ImageTexture.create_from_image(image)
		"LEFTRIGHTSANDFILTER": 
			var image = filter.get_image()
			image.rotate_90(CLOCKWISE)
			return ImageTexture.create_from_image(image)
		"UPDOWNSANDFILTER": 
			return filter
		"LEFTRIGHTCARBONFILTER": 
			var image = filter.get_image()
			image.rotate_90(CLOCKWISE)
			return ImageTexture.create_from_image(image)
		"UPDOWNCARBONFILTER": 
			return filter
		"ROCK":
			var image = rock.get_image()
			var rng: RandomNumberGenerator = RandomNumberGenerator.new()
			var pick_random: Vector2i = Vector2i(rng.randi_range(0,2), rng.randi_range(0,1))
			var one_one: Vector2i = Vector2i(image.get_size().x/3, image.get_size().y/2)
			var rect: Rect2i = Rect2i(one_one*pick_random, one_one)	
			image = image.get_region(rect)
			return ImageTexture.create_from_image(image)
		_: return preload("res://icon.svg")


# Handles when a pipe is dropped
func drop_pipe(dropped_pipe: Pipe) -> void:
	if not grid.pipe_hovered:
		pipes.create_or_add_to_stack(dropped_pipe)
		var tween: Tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(dropped_pipe, "position", Vector2(97.5,97.5), 0.1)
		tween.tween_property(dropped_pipe, "rotation", 0.0, 0.1)
		await tween.finished
	else:
		var grid_coords: Vector2i = grid.position_to_coords(grid.get_local_mouse_position())
		if grid_def.get(grid_coords) == null:
			var val: String = Pipe.directions_to_string(dropped_pipe.holes)
			val += dropped_pipe.filter_type
			grid_def.get_or_add(grid_coords, val)
			last_placed_at.push_front(grid_coords)
			dropped_pipe.queue_free()
			undo.disabled = false
			pipes.order_pipes()
			redraw()
		else:
			pipes.create_or_add_to_stack(dropped_pipe)
			var tween: Tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(dropped_pipe, "position", Vector2(97.5,97.5), 0.1)
			tween.tween_property(dropped_pipe, "rotation", 0.0, 0.1)
			await tween.finished
	$PipeSFX.play()

# Run the water and check if it flows properly
func check_water() -> bool:
	var curr_coords: Vector2i = start_point
	var connecting_from: Pipe.DIRECTIONS = Pipe.DIRECTIONS.UP
	var curr_contents = grid_def.get(curr_coords)
	var filtered_sand = not filters_needed.has("SANDFILTER")
	var filtered_carbon = not filters_needed.has("CARBONFILTER")
	while curr_contents != null:
		if curr_contents != "ROCK":
			draw_water(curr_coords, not filtered_sand, not filtered_carbon)
		if curr_contents.containsn("SANDFILTER"): filtered_sand = true
		elif curr_contents.containsn("CARBONFILTER"): filtered_carbon = true
		if curr_contents == "ROCK": return false
		else:
			var pipe_dir : Array[Pipe.DIRECTIONS] = Pipe.string_to_directions(curr_contents)
			if not pipe_dir.has(connecting_from): return false
			else:
				pipe_dir.erase(connecting_from)
				connecting_from = Pipe.flip_direction(pipe_dir[0])
				if curr_coords == end_point and connecting_from == Pipe.DIRECTIONS.UP:
					await get_tree().create_timer(0.5).timeout
					return filtered_sand and filtered_carbon
				else:
					curr_coords = Pipe.dir_to_vector(pipe_dir[0]) + curr_coords
					curr_contents = grid_def.get(curr_coords)
		await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(0.5).timeout
	return false


func draw_water(coords: Vector2i, dust: bool, organics: bool) -> void:
	if dust or organics:
		grid.place_on_grid(coords, preload("res://assets/minigames/water/water_dirty.png"), "", 0.4)
	else:
		grid.place_on_grid(coords, preload("res://assets/minigames/water/water_clean.png"), "", 0.4)
	if dust:
		grid.place_on_grid(coords, preload("res://assets/minigames/water/water_dirt.png"), "", 0.4)
	if organics:
		grid.place_on_grid(coords, preload("res://assets/minigames/water/water_bio.png"), "", 0.4)


func _on_run_water_pressed() -> void:
	$WaterSFX.play()
	grid.input_pickable = false
	grid.monitoring = false
	grid.monitorable = false
	undo.disabled = true
	$Background/Margins/Top/Back.disabled = true
	$Background/RunWater.disabled = true
	if await check_water():
		modulate = Color.GREEN
		await get_tree().create_timer(1.0).timeout
		score = 1.0
		is_completed = true
		ended.emit(self, score)
		level.do_particles(score)
	else:
		modulate = Color.RED
		await get_tree().create_timer(1.0).timeout
		score = 0.0
		is_completed = true
		ended.emit(self, score)
		level.do_particles(score)


func _on_pause_pressed() -> void:
	$"../../".close_minigame(self)


func _on_undo_pressed() -> void:
	var coords: Vector2i = last_placed_at[0]
	var s: String = grid_def[coords]
	var new_pipe: Pipe = Pipe.create_pipe(s)
	pipes.create_or_add_to_stack(new_pipe)
	new_pipe.grabbed.connect(func(): held_pipe = new_pipe)
	new_pipe.dropped.connect(func(): drop_pipe(new_pipe))
	grid_def.erase(coords)
	last_placed_at.pop_front()
	if last_placed_at.is_empty(): undo.disabled = true
	redraw()
	$PipeSFX.play()


func _ready() -> void:
	if filters_needed:
		filters_needed_label.text = ", ".join(filters_needed.map(func (x: String) -> String:
			match x:
				"SANDFILTER": return "Dust"
				"CARBONFILTER": return "Organics"
				_: return "???"
		))
	else:
		$Background/Margins/Top/Filters.modulate.a = 0.0


func _on_grid_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		var coords: Vector2i = grid.position_to_coords(grid.get_local_mouse_position())
		if coords in grid_def and grid_def[coords] != "ROCK":
			var pipe: Pipe = Pipe.create_pipe(grid_def[coords])
			pipes.create_or_add_to_stack(pipe)
			pipe.grabbed.connect(func(): held_pipe = pipe)
			pipe.dropped.connect(func(): drop_pipe(pipe))
			grid_def.erase(coords)
			last_placed_at.erase(coords)
			if last_placed_at.is_empty(): undo.disabled = true
			redraw()
			$PipeSFX.play()
