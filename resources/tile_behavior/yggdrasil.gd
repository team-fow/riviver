extends YggdrasilTileBehavior

const GRASS_RADIUS: int = 8


func trigger() -> void:
	super()
	await Game.grid.get_tree().create_timer(STEP_TIME * 4).timeout
	tile.radiate_effect(Tile.revitalize, GRASS_RADIUS ** 2, [Tile.Type.WASTELAND, Tile.Type.RIVERBED])



# virtual

func _init(tile: Tile) -> void:
	super(tile)
	clear_radius = 32
