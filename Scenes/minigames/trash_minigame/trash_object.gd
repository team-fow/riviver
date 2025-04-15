class_name TrashObject
extends Draggable

signal eaten

@export_enum("landfill", "recycling", "compost", "hazardous") var category: String = "landfill"

var type: int
var initial_scale: Vector2i = scale


func _drop() -> void:
	for area: Area2D in get_overlapping_areas():
		if area is TrashBin:
			area.eat(self)
			eaten.emit()
			queue_free()


func _mouse_enter() -> void:
	scale = initial_scale * 1.1


func _mouse_exit() -> void:
	scale = initial_scale


func _ready() -> void:
	super()
	$Sprite.texture = load("res://assets/minigames/trash/%s_trash.png" % category)
	$Sprite.hframes = {"landfill": 4, "recycling": 6, "compost": 6, "hazardous": 3}[category]
	$Sprite.frame = randi() % $Sprite.hframes
	type = $Sprite.frame
