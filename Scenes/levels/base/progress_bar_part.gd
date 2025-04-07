extends TextureRect

enum Sprite {
	NOT_COMPLETED,
	BAD, 
	MEDIUM,
	GOOD,
}


func set_sprite(value: Sprite) -> void:
	var sprites = [
		load("res://assets/progressbar/Progress - Not Completed.png"),
		load("res://assets/progressbar/Progress - Bad.png"),
		load("res://assets/progressbar/Progress - Good.png"),
		load("res://assets/progressbar/Progress - Medium.png"),
	]
	texture = sprites[value]
