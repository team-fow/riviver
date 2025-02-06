extends Prop


func _ready() -> void:
	pass


func _tick() -> void:
	if tile.type == Tile.Type.GRASS:
		Game.grid.set_tile(Tile.Type.ASH, tile.coords)
	
	for neighbor: Tile in tile.get_neighbors():
		if neighbor.type == Tile.Type.GRASS:
			neighbor.set_prop(Type.FIRE)
