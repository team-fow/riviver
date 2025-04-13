extends HBoxContainer

@export var level: Level


func _ready() -> void:
	await level.ready
	
	for minigame: Minigame in level.minigames:
		var part: Control = load("res://scenes/levels/base/progress_bar_part.tscn").instantiate()
		minigame.ended.connect(_on_minigame_ended.bind(part))
		part.set_sprite(part.Sprite.NOT_COMPLETED)
		add_child(part)


func _on_minigame_ended(minigame: Minigame, score: float, part: Control) -> void:
	part.set_value(score)
