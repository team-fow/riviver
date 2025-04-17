class_name PipeGrid
extends Area2D

var pipe_hovered : bool

@onready var grid_collision: CollisionShape2D = $GridCollision
@onready var grid_size: Vector2i = grid_collision.shape.size
@onready var cell_size: Vector2 = grid_size / 5.0


func _draw() -> void:
	var points: PackedVector2Array
	for x in range(1,5):
		points.append(Vector2(cell_size.x * x, 0))
		points.append(Vector2(cell_size.x * x, grid_size.y))
	for y in range(1,5):
		points.append(Vector2(0, cell_size.y * y))
		points.append(Vector2(grid_size.y, cell_size.y * y))
	draw_multiline(points, Color("#72523d"))
	draw_rect(Rect2(Vector2.ZERO, grid_size), Color("#72523d"), false)


# Given a texture, places it on the grid at the given coordinates as a Sprite2D
func place_on_grid(coords: Vector2i, t: Texture2D, n: String) -> void:
	var local_coords: Vector2 = coords_to_position(coords)
	var to_place: Sprite2D = Sprite2D.new()
	var grid_size: Vector2 =  grid_collision.shape.size 
	to_place.texture = t
	to_place.position = local_coords
	to_place.scale = Vector2(0.3076923077, 0.3076923077)
	to_place.set_meta("Type", n)
	add_child(to_place)


# Converts grid coordinates to a position on the grid
func coords_to_position(coords: Vector2i) -> Vector2:
	return (Vector2(coords.clampi(0, 4)) + Vector2(0.5, 0.5)) * cell_size


# Converts a position in local coordinates to grid coordinates
func position_to_coords(pos: Vector2) -> Vector2i:
	return (pos / cell_size).floor()


# Detecting when a pipe is dragged over the grid
func _on_area_entered(area: Area2D) -> void:
	if area is Pipe:
		pipe_hovered = true


func _on_area_exited(area: Area2D) -> void:
	if area is Pipe:
		pipe_hovered = false
