class_name Tool
extends Draggable

var initial_position: Vector2 = position
var initial_scale: Vector2 = scale
@export var particle: CompressedTexture2D


func _grab() -> void:
	_display_effect()


func _drop() -> void:
	_display_effect()
	create_tween().tween_property(self, "position", initial_position, 0.1)


# displaying effect

func _display_effect() -> void:
	var will_have_effect: bool = _will_drop_have_effect()
	modulate.a = 1.0 if will_have_effect else 0.5
	scale = (Vector2.ONE if will_have_effect else Vector2(0.9, 0.9)) * initial_scale


func _will_drop_have_effect() -> bool:
	if not held:
		return true
	for area: Area2D in get_overlapping_areas():
		if area is PlantMinigamePlant and area.is_affected_by_tool(self):
			return true
	return false


# virtual

func _ready() -> void:
	super()
	area_entered.connect(_display_effect.unbind(1))
	area_exited.connect(_display_effect.unbind(1))
