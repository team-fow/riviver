class_name TrashBin
extends Area2D

signal trash_added(correct: bool)

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)

@export_enum("landfill", "recycling", "compost", "hazardous") var category: String = "landfill"

var initial_scale: Vector2 = scale

@onready var label: Label = $Sprite/Label


func eat(trash: Draggable) -> void:
	if trash.category != category:
		color(Color.CRIMSON)
		for bin: TrashBin in get_parent().bins:
			if bin.category == trash.category:
				bin.color(Color.LIME)
				break
		trash_added.emit(false)
	else:
		color(Color.LIME)
		trash_added.emit(true)
	$SFX.play(0.0)


func color(color: Color) -> void:
	modulate = color
	await get_tree().create_timer(0.5).timeout
	modulate = Color.WHITE


func _mouse_enter() -> void:
	scale = initial_scale * HOVER_SCALE


func _mouse_exit() -> void:
	scale = initial_scale


func _ready() -> void:
	$Sprite.texture = load("res://assets/minigames/trash/%s_bin.png" % category)
	label.text = category.capitalize()
