class_name TrashObject
extends Draggable

signal eaten

@export_enum("landfill", "recycling", "compost", "hazardous") var category: String = "landfill"

var type: int
@onready var initial_scale: Vector2 = scale
@export var minigame: TrashMinigame


func _drop() -> void:
	for area: Area2D in get_overlapping_areas():
		if area is TrashBin:
			area.eat(self)
			eaten.emit()
			queue_free()
			break


func _mouse_enter() -> void:
	scale = initial_scale * 1.2


func _mouse_exit() -> void:
	scale = initial_scale


func _ready() -> void:
	super()
	$Sprite.texture = load("res://assets/minigames/trash/%s_trash.png" % category)
	$Sprite.hframes = {"landfill": 4, "recycling": 8, "compost": 6, "hazardous": 4}[category]
	$Sprite.frame = randi() % $Sprite.hframes
	type = $Sprite.frame
