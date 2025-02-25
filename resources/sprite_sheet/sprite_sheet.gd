class_name SpriteSheet
extends Resource

enum Picking {
	NONE, ## Uses the first (top-leftmost) sprite.
	RANDOMIZE, ## Uses a random sprite.
	CONNECT_BOUNDARY,
	ANIMATE, ## Uses the sprites as frames of an animation. (currently unimplemented)
}

@export var texture: Texture2D = load("res://assets/tiles/default.png") ## A sheet of sprite textures. Sprites should be of equal size.
@export var sheet_size := Vector2i.ONE ## The number of sprites on the sprite sheet in either direction.
@export var sheet_picking: Picking ## The method by which a sprite is chosen from the sprite sheet.

@export var sprite_offset: Vector2 ## Offset applied when rendering.
var sprite_size: Vector2i ## Calculated size of individual sprites.

var color: Color ## The color of the middle of the first sprite.


## Draws a sprite on a canvas item.
func draw(rid: RID, coords: Vector2i = Vector2i.ZERO) -> void:
	var target_rect := Rect2(-sprite_size/2, sprite_size)
	var src_rect := Rect2(coords * sprite_size, sprite_size)
	target_rect.position += sprite_offset
	RenderingServer.canvas_item_add_texture_rect_region(rid, target_rect, texture, src_rect)


func pick_random() -> Vector2i:
	return Vector2i(randi() % sheet_size.x, randi() % sheet_size.y)


func pick_connected_boundary(direction_1: Grid.Direction, direction_2: Grid.Direction) -> Vector2i:
	return Vector2i(direction_1, direction_2 - direction_1 - 2)



# virtual

func _init() -> void:
	_init_deferred.call_deferred()


func _init_deferred() -> void:
	sprite_size = Vector2i(texture.get_size()) / sheet_size
	color = texture.get_image().get_pixel(12, 8)
