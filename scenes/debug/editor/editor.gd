extends CanvasLayer

var type: Tile.Type

@onready var tile_list: ItemList = $Margins/Tiles/List
@onready var coords_label: Label = $Margins/Bar/Label


func _unhandled_input(event: InputEvent) -> void:
	var coords: Vector2i = Game.grid.point_to_coords(Game.grid.get_local_mouse_position())
	
	if Input.is_action_pressed("click"):
		var tile: Tile = Game.grid.get_tile(coords)
		tile.type = type
	
	if event is InputEventMouseMotion:
		var chunk: GridChunk = Game.grid.get_chunk(Grid.get_chunk_coords(coords))
		if chunk:
			coords_label.text = "Tile: %s\nIn chunk: %s\nChunk: %s\nChunk tile: %s" % [
				str(coords),
				str(coords - chunk.tile_offset),
				str(chunk.chunk_coords),
				str(chunk.tile_offset)
			]



# list

func _ready() -> void:
	for info: TileInfo in Library.tiles:
		tile_list.add_item(info.name, info.sprite_sheet)


func _on_tile_selected(idx: int) -> void:
	type = idx
