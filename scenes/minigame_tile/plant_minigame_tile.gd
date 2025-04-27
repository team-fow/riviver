extends "res://scenes/minigame_tile/minigame_tile.gd"


func _ready() -> void:
	super()
	minigame.ended.connect(_on_minigame_ended.unbind(2))


func _on_minigame_ended() -> void:
	var map: TileMapLayer = $"../"
	map.set_cell(map.local_to_map(position), 4 if minigame.score < 0.75 else 3, Vector2i.ZERO)
