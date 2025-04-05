class_name PipeGrid
extends Area2D

var pipe_hovered : bool
@onready var grid_collision: CollisionShape2D = $GridCollision


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
