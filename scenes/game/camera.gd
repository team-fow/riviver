extends Camera2D
## Manages chunk loading.

const SPEED: float = 250 ## Movement speed.
const LOAD_RANGE: int = 2 ## Distance (in chunks) at which chunks are loaded.
const UNLOAD_RANGE: int = 2 ## Distance (in chunks) at which chunks are unloaded.

var input: Vector2 ## Applied to the position.
var chunk_coords: Vector2i ## The chunk coordinates of the camera's position.


## Controls whether the camera can be moved.
func set_movable(value: bool) -> void:
	set_process_unhandled_input(value)
	set_process(value)
	input = Vector2.ZERO


## Moves the camera to some grid coords.
func move_to(coords: Vector2i) -> void:
	set_movable(false)
	await get_tree().create_tween().tween_property(self, "position", Grid.coords_to_point(coords), 0.1).finished
	set_movable(true)



# virtual

func _process(delta: float) -> void:
	position += input * delta
	
	var new_chunk_coords: Vector2i = Grid.get_chunk_coords(Grid.point_to_coords(position))
	if new_chunk_coords != chunk_coords:
		chunk_coords = new_chunk_coords
		
		# unloading chunks
		for chunk: GridChunk in Game.grid.get_loaded_chunks():
			var diff: Vector2i = (chunk.chunk_coords - chunk_coords).abs()
			if diff[diff.max_axis_index()] > UNLOAD_RANGE:
				Game.grid.unload_chunk(chunk.chunk_coords)
		
		# loading chunks
		for x: int in range(-LOAD_RANGE, LOAD_RANGE + 1):
			for y: int in range(-LOAD_RANGE, LOAD_RANGE + 1):
				var lchunk_coords: Vector2i = chunk_coords + Vector2i(x, y)
				if not Game.grid.is_chunk_loaded(lchunk_coords):
					Game.grid.load_chunk(lchunk_coords)


func _unhandled_key_input(_event: InputEvent) -> void:
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down") * SPEED
	if Input.is_action_pressed("sprint"): input *= 4
