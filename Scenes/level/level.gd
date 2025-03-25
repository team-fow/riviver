class_name Level
extends Node2D

@export var minigames: Array[Minigame] # An array containing all of the minigames present in the level
var minigames_completed : int = 0 # How many minigames the player has currently completed
var scores: Dictionary[Minigame, float] # Stores the score for each minigame

@onready var grid: TileMapLayer = $Grid


# Open a minigame
func open_minigame(game : Minigame) -> void:
	var move_grid: Tween = get_tree().create_tween()
	move_grid.tween_property(grid, "position", Vector2(-250.0, 0.0), 0.1)
	game.show()
	
	
# Close a minigame
func close_minigame(game: Minigame) -> void:
	game.hide()	
	var move_grid: Tween = get_tree().create_tween()
	move_grid.tween_property(grid, "position", Vector2(0.0, 0.0), 0.1)


# Close a completed minigame
func end_minigame(game: Minigame, score: float) -> void:
	minigames_completed += 1
	scores.get_or_add(game, score)
	close_minigame(game)
	
	
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
	for minigame in minigames:
		minigame.started.connect(open_minigame)
		minigame.ended.connect(end_minigame)
