extends BuildingTileBehavior


func input(type: InputType) -> void:
	if type == InputType.CLICK:
		Game.camera.move_to(tile.coords)
