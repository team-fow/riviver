extends CanvasLayer


func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)


func _on_sfx_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)


func _on_back_pressed() -> void:
	Save.read()


func _on_save_pressed() -> void:
	Save.write()


func _on_continue_pressed() -> void:
	queue_free()
