extends Node2D

@export var level_name: String = "Level"
@export_multiline var description: String = "Description"
@export var scene: PackedScene

var locked: bool = true

@onready var sprite: Sprite2D = $Sprite
@onready var stars: Node2D = $Stars


func _ready() -> void:
	var idx: int = get_index()
	if Save.is_level_unlocked(idx):
		locked = false
		sprite.frame = 1
		if Save.is_level_completed(idx):
			sprite.frame = randi_range(2, 3)
	
	var score: float = Save.get_level_score(idx)
	for i: int in stars.get_child_count():
		stars.get_child(i).frame = 1 if score >= (i + 1) / 3.0 else 0
