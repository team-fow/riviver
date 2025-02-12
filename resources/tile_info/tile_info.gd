class_name TileInfo
extends Resource

enum SpriteSheetPicking {
	NONE,
	RANDOMIZE,
	ANIMATE,
}

@export var name: String

@export var sprite_sheet: Texture2D = load("res://assets/tiles/default.png")
@export var sprite_sheet_size := Vector2i.ONE
@export var sprite_sheet_picking: SpriteSheetPicking
var sprite_size: Vector2i
var color: Color

@export var behavior: GDScript



# virtual

func _init() -> void:
	_init_deferred.call_deferred()


func _init_deferred() -> void:
	sprite_size = Vector2i(sprite_sheet.get_size()) / sprite_sheet_size
	color = sprite_sheet.get_image().get_pixel(12, 8)
