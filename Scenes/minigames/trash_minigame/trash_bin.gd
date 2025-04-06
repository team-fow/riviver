class_name TrashBin
extends Area2D

signal trash_added

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)

var initial_scale: Vector2 = scale

@export_enum("landfill", "recycling", "compost", "hazardous") var category: String = "landfill"


func eat(trash: Draggable) -> void:
	if trash.category != category:
		modulate = Color.CRIMSON
		await get_tree().create_timer(0.5).timeout
		modulate = Color.WHITE


func _mouse_enter() -> void:
	scale = initial_scale * HOVER_SCALE


func _mouse_exit() -> void:
	scale = initial_scale
