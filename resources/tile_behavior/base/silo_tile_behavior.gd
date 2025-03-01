class_name SiloTileBehavior
extends BuildingTileBehavior


func start() -> void:
	super()
	var info: SiloTileInfo = tile.get_info()
	Game.player.add_max_material(info.material, info.amount)


func stop() -> void:
	super()
	var info: SiloTileInfo = tile.get_info()
	Game.player.add_max_material(info.material, -info.amount)
