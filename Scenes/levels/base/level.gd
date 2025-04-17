class_name Level
extends Node2D

var minigames: Array[Minigame] # An array containing all of the minigames present in the level
var minigames_completed : int = 0 # How many minigames the player has currently completed
var current_minigame: Minigame # The currently active minigame.

@onready var grid: TileMapLayer = $Grid
@onready var animator: AnimationPlayer = $Animator
@onready var summary: Control = $UI/Summary
@onready var explosion: CPUParticles2D = $UI/Summary/Content/Explosion
@onready var scienceguy: Control = $UI/Margins/Scienceguy
@onready var leaf_particles: GPUParticles2D = $LeafParticles
@onready var petal_particles: GPUParticles2D = $PetalParticles


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
	if game != current_minigame: return
	current_minigame = null
	game.set_paused(true)
	animator.play_backwards("move_grid")


# Close a completed minigame
func end_minigame(game: Minigame, score: float) -> void:
	minigames_completed += 1
	close_minigame(game)
	
	leaf_particles.emitting = true
	if score == 1.0: petal_particles.emitting = true
	
	if minigames_completed == minigames.size():
		var total_score: float = 0.0
		for minigame: Minigame in minigames:
			total_score += minigame.score
		Save.set_level_score(Save.get_current_level(), total_score / minigames.size())
		do_summary()



# summary

func do_summary() -> void:
	summary.show()
	
	var score: float = Save.get_level_score(Save.get_current_level())
	var stars: Control = summary.get_node("Content/Stars")
	for i: int in stars.get_child_count():
		stars.get_child(i).get_child(0).visible = score >= (i + 1) / 3.0
	
	animator.play("open_summary")
	await animator.animation_finished

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
		if minigame is Minigame:
			minigames.append(minigame)
			minigame.started.connect(open_minigame)
			minigame.ended.connect(end_minigame)
	do_tutorial(Save.get_current_level())


func do_tutorial(idx: int) -> void:
	scienceguy.show()
	
	match idx:
		0:
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("Gah! So much trash! It looks like someone has been littering...")
			await scienceguy.set_text("This is unacceptable! We need to clean this up!")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Find trash in the world.")
			await scienceguy.set_text("Then, click and hold to drag it to our trash bins!")
			await scienceguy.set_text("We have to be careful to put each piece of trash in the right bin...")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("If the trash isn't sorted right, the recycling center can't recycle it.")
		1:
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("That factory looks like it has a leak.")
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("All those dirty chemicals will make our water dirty too!")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Click the factory to investigate.")
			await scienceguy.set_text("To fix the leak, drag pipes onto the ground and connect them together.")
			await scienceguy.set_text("You can't place pipes on rocks, so plan around them!")
			await scienceguy.set_text("Remember to use special filter pipes to clean the water!")
		2:
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("Our river is eroding! The dirt is being swept away by the water.")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Luckily, plants' roots can stop erosion!")
			await scienceguy.set_text("Click on a sandy riverbank and use our tools to plant a plant!")
			await scienceguy.set_text("Use the tools by dragging and wiggling them over the plant spots in order.")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("Be quick! After some time, rain will sweep away the rest of the dirt.")
	
	scienceguy.hide()
