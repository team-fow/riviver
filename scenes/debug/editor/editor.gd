extends CanvasLayer

enum Tool {TYPE}

var tool: Tool
var type: Tile.Type

@onready var tool_list: ItemList = $Margins/Toolbox/Tools
@onready var tile_list: ItemList = $Margins/Toolbox/Tiles
@onready var coords_label: Label = $Margins/Bar/Label


func _unhandled_input(event: InputEvent) -> void:
	var coords: Vector2i = Grid.point_to_coords(Game.grid.get_local_mouse_position())
	
	match tool:
		Tool.TYPE:
			if Input.is_action_pressed("click"):
				Game.grid.get_tile(coords).type = type
	
	if event is InputEventMouseMotion:
		var chunk: GridChunk = Game.grid.get_chunk(Grid.get_chunk_coords(coords))
		if chunk:
			coords_label.text = "Type: %s\nCoords: %s\nChunk coords: %s" % [
				Game.grid.get_tile(coords).get_info().name,
				str(coords),
				str(chunk.chunk_coords),
			]



# list

func _ready() -> void:
	for info: TileInfo in Library.tiles:
		tile_list.add_item(info.name, info.sprite_sheet.texture)
	
	tool_list.select(0)
	tile_list.select(0)


func _on_tile_selected(idx: int) -> void:
	type = idx as Tile.Type


func _on_tool_selected(idx: int) -> void:
	tool = idx as Tool



# saving loading

func _on_save_pressed() -> void:
	Game.write()


func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()


func _on_reset_pressed() -> void:
	Game.file.clear()
	DirAccess.remove_absolute("user://save.ini")
	get_tree().reload_current_scene()
