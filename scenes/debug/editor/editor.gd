extends CanvasLayer

enum Tool {NONE, TYPE, HIGHLIGHT}

var tool: Tool
var type: Tile.Type

@onready var tools: ItemList = $Margins/Toolbox/Tools
@onready var tiles: ItemList = $Margins/Toolbox/Tiles
@onready var coords_label: Label = $Margins/Bar/Label


func _unhandled_input(event: InputEvent) -> void:
	var coords: Vector2i = Grid.point_to_coords(Game.grid.get_local_mouse_position())
	
	match tool:
		Tool.TYPE:
			if Input.is_action_pressed("click"):
				Game.grid.get_tile(coords).type = type
		
		Tool.HIGHLIGHT:
			if event.is_action_pressed("click"):
				pass
			if event.is_action_released("click"):
				pass
	
	if event is InputEventMouseMotion:
		var chunk: Chunk = Game.grid.get_chunk(Grid.get_chunk_coords(coords))
		if chunk:
			coords_label.text = "Type: %s\nCoords: %s\nChunk coords: %s" % [
				Game.grid.get_tile(coords).get_info().name,
				str(coords),
				str(chunk.chunk_coords),
			]



# list

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	for info: TileInfo in ResourceLibrary.tiles:
		var icon := AtlasTexture.new()
		icon.atlas = info.sprite_sheet.texture
		icon.region.size = Vector2(info.sprite_sheet.sprite_size)
		tiles.add_item(info.name, icon)
	
	tools.select(0)
	tiles.select(0)


func _on_tile_selected(idx: int) -> void:
	type = idx as Tile.Type


func _on_tool_selected(idx: int) -> void:
	tool = idx as Tool
	
	tiles.visible = tool == Tool.TYPE



# saving loading

func _on_save_pressed() -> void:
	Game.write()


func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()


func _on_reset_pressed() -> void:
	Game.delete_save()
	get_tree().reload_current_scene()
