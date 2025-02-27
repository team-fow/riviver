extends WorldtreeTileBehavior

const GRASS_RADIUS: int = 8


func trigger() -> void:
	super()
	await Game.grid.get_tree().create_timer(0.25).timeout
	Game.grid.radiate_effect(tile, Tile.revitalize, Tile.has_tag.bind("wasteland"), GRASS_RADIUS ** 2)



# virtual

func _init(tile: Tile) -> void:
	super(tile)
	clear_radius = 32
