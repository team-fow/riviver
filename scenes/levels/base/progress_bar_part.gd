extends TextureRect

enum Sprite {
	NOT_COMPLETED,
	BAD, 
	MEDIUM,
	GOOD,
}


func set_value(score: float) -> void:
	$Label.text = str(roundi(score * 100)) + "%"
	if score < 0.5:
		set_sprite(Sprite.BAD)
	elif score < 1.0:
		set_sprite(Sprite.MEDIUM)
	else:
		set_sprite(Sprite.GOOD)


func set_sprite(value: Sprite) -> void:
	var sprites = [
		load("res://assets/progressbar/Progress - Not Completed.png"),
		load("res://assets/progressbar/Progress - Bad.png"),
		load("res://assets/progressbar/Progress - Good.png"),
		load("res://assets/progressbar/Progress - Medium.png"),
	]
	texture = sprites[value]
