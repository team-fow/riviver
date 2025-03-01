class_name HarvesterTileBehavior
extends BuildingTileBehavior

const HIGHLIGHT_COLOR := Color("#bfff80")


func start() -> void:
	super()
	Game.clock.day_ended.connect(harvest)


func harvest() -> void:
	var info: HarvesterTileInfo = tile.get_info()
	Game.player.add_material(info.output_material, get_valid_tiles().size())


func get_valid_tiles() -> Array[Tile]:
	var info: HarvesterTileInfo = tile.get_info()
	return Game.grid.expand_neighborhood([tile], Tile.is_type.bind(info.input_tiles), info.input_depth)


func stop() -> void:
	super()
	Game.clock.day_ended.disconnect(harvest)


func input(event: InputType) -> void:
	match event:
		InputType.MOUSE_ENTER:
			for tile: Tile in get_valid_tiles():
				Game.grid.add_highlight(tile.coords, HIGHLIGHT_COLOR)
		InputType.MOUSE_EXIT:
			for tile: Tile in get_valid_tiles():
				Game.grid.remove_highlight(tile.coords)
