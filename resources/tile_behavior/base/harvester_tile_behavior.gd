class_name HarvesterTileBehavior
extends BuildingTileBehavior


func start() -> void:
	super()
	Game.clock.day_ended.connect(harvest)


func harvest() -> void:
	var info: HarvesterTileInfo = tile.get_info()
	Game.player.add_material(info.output_material, Game.grid.get_tiles_in_radius(tile, Tile.is_type.bind(info.input_tiles), info.input_radius).size())


func stop() -> void:
	super()
	Game.clock.day_ended.disconnect(harvest)
