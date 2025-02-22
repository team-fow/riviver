class_name TileInfo
extends Resource

@export var name: String ## The name of the tile.

@export var sprite_sheet: SpriteSheet ## Sprite sheet rendered by the tile.
@export var material: Material ## Material applied when rendering.
@export var z_index: int ## Z-index applied when rendering.

@export var behavior: GDScript ## Custom behavior script.
@export var flammable: bool ## Whether fire can damage this tile.
