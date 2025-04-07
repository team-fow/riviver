extends ColorRect

const AUDIO: AudioStream = preload("res://assets/intro.mp3")


func _on_audio_stream_player_finished() -> void:
	Save.start_music()
	Save.change_scene("res://scenes/worldmap/worldmap.tscn")
