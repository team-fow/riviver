extends TileMapLayer

const PRESSED_SCALE: float = 0.99

var mouse_coords: Vector2i
var prev_mouse_coords: Vector2i

@onready var initial_scale: Vector2 = scale


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event is InputEventMouseMotion:
			mouse_coords = local_to_map(get_local_mouse_position())
			if mouse_coords != prev_mouse_coords:
				notify_runtime_tile_data_update()
				prev_mouse_coords = mouse_coords
		
		elif mouse_coords in get_used_cells():
			if event.is_action_pressed("click"):
				var particles = preload("res://scenes/click_particles.tscn").instantiate()
				particles.position = get_local_mouse_position()
				particles.set_type("water" if get_cell_source_id(mouse_coords) in [0, 4, 5] else "grass")
				add_child(particles)
				_scale(PRESSED_SCALE)
			elif event.is_action_released("click"):
				_scale(1.0)


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return coords == mouse_coords


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.modulate.v = 1.1


func _scale(value: float) -> void:
	create_tween().tween_property(self, "scale", initial_scale * value, 0.05).set_ease(Tween.EASE_IN)
