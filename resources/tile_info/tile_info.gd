class_name TileInfo
extends Resource

enum Tag {
	FLAMMABLE,
}

@export var name: String ## The name of the tile.

@export_group("Rendering")
@export var sprite_sheet: SpriteSheet ## Sprite sheet rendered by the tile.
@export var material: Material ## Material applied when rendering.
@export var z_index: int ## Z-index applied when rendering.

@export_group("Behavior")
@export var behavior: GDScript ## Custom behavior script.
@export var tags: Array[Tag] ## Tags read by other code.
