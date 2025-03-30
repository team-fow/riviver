class_name Level
extends Node2D

var minigames: Array[Minigame] # An array containing all of the minigames present in the level
var minigames_completed : int = 0 # How many minigames the player has currently completed
var current_minigame: Minigame # The currently active minigame.

@onready var grid: TileMapLayer = $Grid
@onready var animator: AnimationPlayer = $Animator
@onready var hbox_container: HBoxContainer = $UI/HBoxContainer


# Open a minigame
func open_minigame(game : Minigame) -> void:
	if current_minigame:
		current_minigame.set_paused(true)
	else:
		animator.play("move_grid")
	current_minigame = game
	game.set_paused(false)
	game.show()
	
	
# Close a minigame
func close_minigame(game: Minigame) -> void:
	current_minigame = null
	game.set_paused(true)
	animator.play_backwards("move_grid")


# Close a completed minigame
func end_minigame(game: Minigame, score: float) -> void:
	minigames_completed += 1
	close_minigame(game)
	
	if minigames_completed == minigames.size():
		var total_score: float = 0.0
		for minigame: Minigame in minigames:
			total_score += minigame.score
		Save.set_level_score(Save.current_level, total_score / minigames.size())
		get_tree().change_scene_to_file("res://scenes/worldmap/worldmap.tscn")


# Return the player to the world map
func _on_back_pressed() -> void:
	pass # Replace with function body.


# Reset the current level
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


# Open the settings menu
func _on_settings_pressed() -> void:
	pass # Replace with function body.
	

func _ready() -> void:
	for minigame in $Minigames.get_children():
		minigames.append(minigame)
		minigame.started.connect(open_minigame)
		minigame.ended.connect(end_minigame)
	
	for i in 3:
		var bar_part = load("res://scenes/minigames/plant_minigame/plant.tscn").instantiate()
		hbox_container.add_child(bar_part)


func _on_restart_pressedagzaga() -> void:
	var wdwdwdwd: Node = load("res://scenes/minigames/plant_minigame/g.tscn").instantiate()
	add_child(wdwdwdwd)
