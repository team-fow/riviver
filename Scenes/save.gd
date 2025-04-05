extends Node

var data: Dictionary = {
	"name": "Player",
	"levels": [0.0, 0.0, 0.0],
}

var current_level: int

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



# file

func write() -> void:
	var file: FileAccess = FileAccess.open("user://save.cfg", FileAccess.WRITE)
	file.store_var(data)
	file.close()


func read() -> void:
	data = bytes_to_var(FileAccess.get_file_as_bytes("user://save.cfg"))
	get_tree().reload_current_scene()



# transition

func change_scene(file: String) -> void:
	overlay_color.show()
	animator.play("fade_in")
	await animator.animation_finished
	get_tree().change_scene_to_file(file)
	animator.play_backwards("fade_in")
	await animator.animation_finished
	overlay_color.hide()
