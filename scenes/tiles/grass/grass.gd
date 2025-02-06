extends Tile


func _ready() -> void:
	_sprite.frame = randi() % _sprite.hframes


func _tick() -> void:
	for neighbor: Tile in get_neighbors():
		if neighbor.type == Type.DIRT:
			Game.grid.set_tile(Type.GRASS, neighbor.coords)
