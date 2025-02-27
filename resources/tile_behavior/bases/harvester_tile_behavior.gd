class_name HarvesterTileBehavior
extends BuildingTileBehavior


func start() -> void:
	super()
	# Game.clock.day_ended.connect(harvest)


func harvest() -> void:
	pass


func stop() -> void:
	super()
	# Game.clock.day_ended.disconnect(harvest)
