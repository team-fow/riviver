extends ColorRect

const AUDIO: AudioStream = preload("res://assets/audio/intro.mp3")


func _on_audio_stream_player_finished() -> void:
	Save.change_scene("res://scenes/gradeselect/gradeselect.tscn")


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		$Music.stop()
		_on_audio_stream_player_finished()
