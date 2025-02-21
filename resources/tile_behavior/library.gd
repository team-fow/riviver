extends TileBehavior


func input(event: InputEventMouseButton) -> void:
	if event.pressed:
		Game.camera.move_to(tile.coords)
