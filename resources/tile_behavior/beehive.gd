extends DenTileBehavior


func _init(tile : Tile) -> void:
	super(tile)
	task_data = [load("res://resources/task_info/nearby_water.tres")]
