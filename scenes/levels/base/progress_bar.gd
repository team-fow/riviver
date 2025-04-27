extends HBoxContainer

@export var level: Level
var tween: Tween


func _ready() -> void:
	await level.ready
	
	for minigame: Minigame in level.minigames:
		var part: Control = load("res://scenes/levels/base/progress_bar_part.tscn").instantiate()
		minigame.ended.connect(_on_minigame_ended.bind(part))
		part.set_sprite(part.Sprite.NOT_COMPLETED)
		add_child(part)


func _on_minigame_ended(minigame: Minigame, score: float, part: Control) -> void:
	pivot_offset = size/2.0
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2,1.2),0.2)
	await tween.finished
	part.set_value(score)
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0),0.2)
	await tween.finished
