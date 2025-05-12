extends ColorRect


func _on_button_pressed(grade: int) -> void:
	match grade:
		2: Save.data.timer_length = 4.0
		3: Save.data.timer_length = 2.0
		_: Save.data.timer_length = 1.0
	Save.start_music()
	Save.change_scene("res://scenes/worldmap/worldmap.tscn")
