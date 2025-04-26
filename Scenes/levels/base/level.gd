class_name Level
extends Node2D

var minigames: Array[Minigame] # An array containing all of the minigames present in the level
var minigames_completed : int = 0 # How many minigames the player has currently completed
var current_minigame: Minigame # The currently active minigame.

@onready var grid: TileMapLayer = $Grid
@onready var animator: AnimationPlayer = $Animator
@onready var summary: Control = $UI/Summary
@onready var scienceguy: Control = $UI/Margins/Scienceguy
@onready var leaf_particles: GPUParticles2D = $LeafParticles
@onready var petal_particles: GPUParticles2D = $PetalParticles
@onready var pointer_tutorial: PointerTutorial = $PointerTutorial


# Open a minigame
func open_minigame(game : Minigame) -> void:
	if current_minigame:
		current_minigame.set_paused(true)
	else:
		animator.play("move_grid")
	create_tween().tween_property(grid, "modulate", Color.WHITE if game is TrashMinigame else Color.GRAY, 0.1)
	$Minigames/Animator.play("bob")
	current_minigame = game
	game.set_paused(false)
	game.show()
	
	
# Close a minigame
func close_minigame(game: Minigame) -> void:
	create_tween().tween_property(grid, "modulate", Color.WHITE, 0.1)
	if game != current_minigame: return
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
		Save.set_level_score(Save.get_current_level(), total_score / minigames.size())
		do_summary()


func do_particles(score: float) -> void:
	leaf_particles.emitting = true
	if score == 1.0: petal_particles.emitting = true



# summary

func do_summary() -> void:
	await get_tree().create_timer(0.75).timeout
	
	var score: float = Save.get_level_score(Save.get_current_level())
	var stars: Array[Control] = [summary.get_node("Star1"), summary.get_node("Star2"), summary.get_node("Star3")]
	for i: int in stars.size():
		stars[i].get_child(0).visible = score >= (i + 1) / 3.0
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
			minigame.pointer = pointer_tutorial
	await do_tutorial(Save.get_current_level())
	if not Save.get_pointer_done(0) && grid.get_children().any(func(tile): return tile is TrashObject):
		for i in 2:
			var tutorial_object : TrashObject = grid.get_children().filter(func(tile): return tile is TrashObject)[0]
			var trash_minigame = tutorial_object.minigame
			await pointer_tutorial.tutorial_point(tutorial_object.global_position, trash_minigame.global_position)
		Save.set_pointer_done(0)


func do_tutorial(idx: int) -> void:
	scienceguy.show()
	
	match idx:
		0:
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("Gah! Some trash! It looks like someone has been littering...")
			await scienceguy.set_text("This is unacceptable! We need to clean this up!")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Find trash in the level behind me.")
			await scienceguy.set_text("Click on a piece of trash, hold it down, and then move the cursor around.")
			await scienceguy.set_text("Then drag the trash into our trash bins!")
			pointer_tutorial.tutorial_point(grid.get_child(0).global_position, $Minigames/TrashMinigame/TrashBin.global_position)
		1:
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Great job on finding and removing trash!")
			await scienceguy.set_text("Now, be extra careful...")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("Put each piece of trash in the right bin...")
			await scienceguy.set_text("If the trash isn't sorted right, no one will be able to recycle.")
		2:
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("What's going on here? There's trash laying around, but also...")
			await scienceguy.set_text("That factory has a leak! It's leaking into the river.")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Click on the factory!")
			if grid.has_node("WaterTile"):
				scienceguy.hide()
				await $Grid/WaterTile.clicked
				scienceguy.show()
				scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
				await scienceguy.set_text("Hmm, what a mess....")
				scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
				await scienceguy.set_text("You can drag pipes onto the dirt.")
				await scienceguy.set_text("Using the pipes, make a path from top to bottom...")
				await scienceguy.set_text("That way, water can pass through without leaking.")
				await scienceguy.set_text("Remember that you can't place pipes on rocks.")
		3:
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Nice job!")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("This factory is leaking bad chemicals!")
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("All the dirty chemicals will make our water dirty too!")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Try using a filter! Filters clean water.")
		4:
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("Oh no!")
			await scienceguy.set_text("The ground is being taken away by the water... Our river is eroding!")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Luckily, plants' roots can stop eroding!")
			await scienceguy.set_text("Click on a sandy riverbank.")
			await scienceguy.set_text("Use our gardening tools to plant a plant. Drag them and wiggle them around!")
			await scienceguy.set_text("First shovel the ground, then plant a seed...")
			await scienceguy.set_text("Then add soil, and finally water it!")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("Be quick! After some time, rain will sweep away the rest of the dirt.")
		5:
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("I'm proud of you.")
			await scienceguy.set_text("The world is looking much prettier, wouldn't you agree?")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("This is the final level...")
			await scienceguy.set_text("It's hard, but I believe in you!")
	
	scienceguy.hide()


func _on_next_level_pressed() -> void:
	get_tree().reload_current_scene()


func _on_world_map_pressed() -> void:
	Save.change_scene("res://scenes/worldmap/worldmap.tscn")
