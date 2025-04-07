class_name Level
extends Node2D

var minigames: Array[Minigame] # An array containing all of the minigames present in the level
var minigames_completed : int = 0 # How many minigames the player has currently completed
var current_minigame: Minigame # The currently active minigame.

@onready var grid: TileMapLayer = $Grid
@onready var animator: AnimationPlayer = $Animator
@onready var help_panel: PanelContainer = $UI/Margins/HelpPanel
@onready var summary: Control = $UI/Summary
@onready var explosion: CPUParticles2D = $UI/Summary/Content/Explosion


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
		do_summary()



# summary

func do_summary() -> void:
	summary.show()
	animator.play("open_summary")
	await animator.animation_finished
	
	var score: float = Save.get_level_score(Save.current_level)
	var stars: Control = summary.get_node("Content/Stars")
	for i: int in stars.get_child_count():
		stars.get_child(i).get_child(0).visible = score >= (i + 1) / 3.0
	
	explosion.speed_scale = explosion.speed_scale * score
	explosion.lifetime = explosion.lifetime * score

	summary.mouse_filter = Control.MOUSE_FILTER_PASS

func _on_summary_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		Save.change_scene("res://scenes/worldmap/worldmap.tscn")



# other stuff

# Return the player to the world map
func _on_back_pressed() -> void:
	Save.change_scene("res://scenes/worldmap/worldmap.tscn")


# Reset the current level
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


# Open the settings menu
func _on_settings_pressed() -> void:
	add_child(load("res://scenes/settings/settings.tscn").instantiate())


func _on_help_pressed() -> void:
	pass
	

func _ready() -> void:
	for minigame in $Minigames.get_children():
		minigames.append(minigame)
		minigame.started.connect(open_minigame)
		minigame.ended.connect(end_minigame)


func _on_help_list_item_selected(idx: int) -> void:
	if idx == 3: return
	
	var text: String
	
	if idx == 0: text = "Trash"
	elif idx == 1: text = "Water"
	elif idx == 2: text = "Plant"
	
	help_panel.get_node("Label").text = text
	help_panel.show()


func _on_help_panel_gui_input(event: InputEvent) -> void:
	if event.is_action("click"):
		help_panel.hide()
