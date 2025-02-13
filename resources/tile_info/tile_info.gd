class_name TileInfo
extends Resource

enum SpriteSheetPicking {
	NONE, ## Uses the first (top-leftmost) sprite.
	RANDOMIZE, ## Uses a random sprite.
	ANIMATE, ## Uses the sprites as frames of an animation. (currently unimplemented)
}

@export var name: String ## The name of the tile.

@export var sprite_sheet: Texture2D = load("res://assets/tiles/default.png") ## A sheet of textures used by the tile.
@export var sprite_sheet_size := Vector2i.ONE ## The number of sprites on the sprite sheet in either direction.
@export var sprite_sheet_picking: SpriteSheetPicking ## The method by which a sprite is chosen from the sprite sheet.
var sprite_size: Vector2i ## The size of individual tile sprites.
var color: Color ## The color of the middle of the first sprite.

@export var behavior: GDScript ## Custom behavior script.



# virtual

func _init() -> void:
	_init_deferred.call_deferred()


func _init_deferred() -> void:
	sprite_size = Vector2i(sprite_sheet.get_size()) / sprite_sheet_size
	color = sprite_sheet.get_image().get_pixel(12, 8)
