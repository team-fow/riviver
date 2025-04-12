class_name PipeGrid
extends Area2D

var pipe_hovered : bool
@onready var grid_collision: CollisionShape2D = $GridCollision


func _draw() -> void:
	var grid_size: Vector2 =  grid_collision.shape.size 
	var grid_top_left: Vector2 = Vector2(-grid_size.x/2.0, -grid_size.y/2.0)
	var grid_fifth: Vector2 = grid_size/5.0
	var points: PackedVector2Array
	for i in range(1,5):
		var point_a: Vector2 = Vector2(grid_top_left.x + (grid_fifth.x * i), grid_top_left.y)
		var point_b: Vector2 = Vector2(grid_top_left.x + (grid_fifth.x * i), grid_top_left.y + grid_size.y)
		points.append_array([point_a, point_b])
	for i in range(1,5):
		var point_a: Vector2 = Vector2(grid_top_left.x, grid_top_left.y + (grid_fifth.y * i))
		var point_b: Vector2 = Vector2(grid_top_left.x + grid_size.x, grid_top_left.y + (grid_fifth.y * i))
		points.append_array([point_a, point_b])
	draw_multiline(points, Color.WEB_GRAY)


# Given a texture, places it on the grid at the given coordinates as a Sprite2D
func place_on_grid(coords: Vector2i, t: Texture2D, n: String) -> void:
	var local_coords: Vector2 = coords_to_position(coords)
	var to_place: Sprite2D = Sprite2D.new()
	var grid_size: Vector2 =  grid_collision.shape.size 
	to_place.texture = t
	to_place.position = local_coords
	to_place.scale = Vector2(0.12, 0.12)
	to_place.set_meta("Type", n)
	add_child(to_place)


# Converts grid coordinates to a position on the grid
func coords_to_position(coords: Vector2i) -> Vector2:
	coords =  Vector2i(clampi(coords.x, 0, 4), clampi(coords.y, 0, 4))
	var grid_size: Vector2 =  grid_collision.shape.size 
	var grid_top_left: Vector2 = Vector2(-grid_size.x/2.0, -grid_size.y/2.0)
	var pos : Vector2 = grid_top_left + Vector2(grid_size.x/10.0, grid_size.y/10.0)
	pos += Vector2((grid_size.x/5.0)*coords.x, (grid_size.y/5.0)*coords.y) 
	return pos


# Converts a position in local coordinates to grid coordinates
func position_to_coords(pos: Vector2) -> Vector2i:
	var grid_size: Vector2 =  grid_collision.shape.size 
	var grid_top_left: Vector2 = Vector2(-grid_size.x/2.0, -grid_size.y/2.0)
	pos = pos - grid_top_left
	pos = pos * 4.0/(grid_size.x)
	return pos.round()


# Detecting when a pipe is dragged over the grid
func _on_area_entered(area: Area2D) -> void:
	if area is Pipe:
		pipe_hovered = true


func _on_area_exited(area: Area2D) -> void:
	if area is Pipe:
		pipe_hovered = false
