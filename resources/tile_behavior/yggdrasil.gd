extends YggdrasilTileBehavior

const GRASS_RADIUS: int = 8


func trigger() -> void:
	super()
	await Game.grid.get_tree().create_timer(STEP_TIME * 4).timeout
	_radiate_effect(tile, [Tile.Type.WASTELAND, Tile.Type.RIVERBED], _grow_grass, GRASS_RADIUS ** 2)


func _grow_grass(target: Tile) -> void:
	match target.type:
		Tile.Type.WASTELAND: target.type = Tile.Type.GRASS
		Tile.Type.RIVERBED: target.type = Tile.Type.RIVER



# virtual

func _init(tile: Tile) -> void:
	super(tile)
	clear_radius = 32
