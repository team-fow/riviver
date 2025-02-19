extends Control

const RANGE: int = 200



# drawing

func _draw() -> void:
	for chunk: GridChunk in Game.grid.get_loaded_chunks():
		draw_chunk(chunk)


func draw_chunk(chunk: GridChunk) -> void:
	for x: int in GridChunk.SIZE.x:
		for y: int in GridChunk.SIZE.y:
			draw_tile(chunk.get_tile(chunk.tile_offset + Vector2i(x, y)))


func draw_tile(tile: Tile) -> void:
	draw_rect(Rect2(tile.coords.x * 2, tile.coords.y, 2, 1), tile.get_info().sprite_sheet.color)



# virtual

func _ready() -> void:
	await get_tree().process_frame
	Game.tick_timer.timeout.connect(queue_redraw)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("show_map"):
		visible = !visible
