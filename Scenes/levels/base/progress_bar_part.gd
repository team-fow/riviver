extends TextureRect


func set_sprite(value):
	var sprites = [
		load("res://assets/progressbar/Progress - Not Completed.png"),
		load("res://assets/progressbar/Progress - Bad.png"),
		load("res://assets/progressbar/Progress - Medium.png"),
		load("res://assets/progressbar/Progress - Good.png"),
	]
	
	texture = sprites[value]


func _ready() -> void:
	set_sprite(2)
