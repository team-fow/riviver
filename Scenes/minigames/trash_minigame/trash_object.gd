class_name TrashObject
extends Draggable

@export_enum("landfill", "recycling", "compost", "hazardous") var category: String = "landfill"


func _drop() -> void:
	for area: Area2D in get_overlapping_areas():
		if area is TrashBin:
			area.eat(self)
			queue_free()


func _ready() -> void:
	super()
	$Sprite.texture = load("res://assets/minigames/trash/%s_trash.png" % category)
	$Sprite.hframes = {"landfill": 4, "recycling": 6, "compost": 6, "hazardous": 3}[category]
	$Sprite.frame = randi() % $Sprite.hframes
