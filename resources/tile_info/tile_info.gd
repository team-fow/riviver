class_name TileInfo
extends Resource

@export var name: String ## The name of the tile.

@export_group("Sprite", "sprite_")
@export var sprite_sheet: SpriteSheet = load("res://resources/sprite_sheet/default.tres") ## Sprite sheet rendered by the tile.
@export var sprite_material: Material ## Material applied when rendering.
@export var sprite_z_index: int ## Z-index applied when rendering.

@export_group("Behavior")
@export var behavior: GDScript ## Custom behavior script.
@export var tags: PackedStringArray ## Tags read by other code.
