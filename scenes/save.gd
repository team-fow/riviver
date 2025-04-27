extends Node

var data: Dictionary = {
	"name": "Player",
	"levels": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	"current_level": 0,
	"pointer_tutorials_done": [false, false, false]
}

@onready var animator: AnimationPlayer = $Animator
@onready var overlay_color: Control = $Overlay/ColorRect



# levels

## Returns a level's score. Returns 0 if the level hasn't been completed.
func get_level_score(idx: int) -> float:
	return data.levels[idx]


## Returns true if a level's score is high enough to be considered completed.
func is_level_completed(idx: int) -> bool:
	return get_level_score(idx) > 0.33


## Returns true if a level has been unlocked.
func is_level_unlocked(idx: int) -> bool:
	return idx == 0 or is_level_completed(idx - 1)


## Sets a level's score.
func set_level_score(idx: int, score: float) -> void:
	data.levels[idx] = maxf(score, data.levels[idx])


func get_current_level() -> int:
	return data.current_level


func set_current_level(idx: int) -> void:
	data.current_level = idx


## Returns whether the pointer tutorial for a minigame is done (0 -> Trash, 1 -> Water, 2 -> Plant)
func get_pointer_done(idx: int) -> bool:
	return data.pointer_tutorials_done[idx]
	

func set_pointer_done(idx: int) -> void:
	data.pointer_tutorials_done[idx] = true

# file

func write() -> void:
	var file: FileAccess = FileAccess.open("user://save.cfg", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func read() -> void:
	if not FileAccess.file_exists("user://save.cfg"): return
	data = JSON.parse_string(FileAccess.get_file_as_string("user://save.cfg"))
	change_scene("res://scenes/worldmap/worldmap.tscn")



# transition

func change_scene(file: String) -> void:
	overlay_color.show()
	animator.play("fade_in")
	await animator.animation_finished
	get_tree().change_scene_to_file(file)
	animator.play_backwards("fade_in")
	await animator.animation_finished
	overlay_color.hide()


func start_music() -> void:
	$Music.play()



# screenshot

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		get_viewport().get_texture().get_image().save_png("user://screenshot_%s.png" % Time.get_datetime_string_from_system())



# sfx

func play_sfx(stream: AudioStreamMP3) -> void:
	var player := AudioStreamPlayer.new()
	player.bus = &"SFX"
	player.stream = stream
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
