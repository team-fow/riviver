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
	fade_grid(game is not TrashMinigame)
	$Minigames/Animator.play("bob")
	current_minigame = game
	game.set_paused(false)
	game.show()
	
	
# Close a minigame
func close_minigame(game: Minigame) -> void:
	fade_grid(false)
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
		total_score /= minigames.size()
		Save.set_level_score(Save.get_current_level(), total_score)
		do_summary()


func do_particles(score: float) -> void:
	leaf_particles.emitting = true
	if score == 1.0: petal_particles.emitting = true


func fade_grid(value: bool) -> void:
	create_tween().tween_property(grid, "modulate", Color.GRAY if value else Color.WHITE, 0.1)



# summary

func do_summary() -> void:
	await get_tree().create_timer(2.0).timeout
	
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
	toggle_dialogue(true)
	
	match idx:
		0:
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("Gah! Trash!")
			await scienceguy.set_text("It looks like someone has been littering...")
			await scienceguy.set_text("We need to clean this up!")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Click on a piece of trash.")
			await scienceguy.set_text("Hold and drag the trash into our trash bins!")
			pointer_tutorial.tutorial_point(grid.get_child(0).global_position, $Minigames/TrashMinigame/TrashBin.global_position)
		1:
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Great job!")
			await scienceguy.set_text("Now, be extra careful...")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("To recycle, we need to sort our trash.")
			await scienceguy.set_text("Put each piece of trash in the right bin.")
			await scienceguy.set_text("If the trash isn't sorted right...")
			await scienceguy.set_text("...no one will be able to recycle.")
			if has_node("Minigames/TrashMinigame"):
				toggle_dialogue(false)
				await $Minigames/TrashMinigame.unpaused
				toggle_dialogue(true)
				scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
				await scienceguy.set_text("The recycling bin...")
				await scienceguy.set_text("...is for clean paper, plastic, glass, and metal.")
		2:
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("Oh no!")
			scienceguy.set_sprite(scienceguy.Sprite.EVIL)
			await scienceguy.set_text("AHAHA!!! You're no match for my evil FACTORY!")
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("It's Polluto!")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("That factory has a leak! It's leaking into the river.")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Click on the factory!")
			if has_node("Minigames/WaterMinigame"):
				toggle_dialogue(false)
				await $Minigames/WaterMinigame.unpaused
				toggle_dialogue(true)
				scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
				await scienceguy.set_text("What a mess!")
				scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
				await scienceguy.set_text("Use the mouse to drag pipes onto the dirt.")
				await scienceguy.set_text("Make a path from top to bottom...")
				await scienceguy.set_text("That way, water can pass through without leaking.")
				await scienceguy.set_text("Remember: you can't place pipes on rocks.")
		3:
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("That was great!")
			await scienceguy.set_text("Hold on...")
			scienceguy.set_sprite(scienceguy.Sprite.EVIL)
			await scienceguy.set_text("Raghaghah!")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("This factory is leaking dirty water!")
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("All the dirt will make the river dirty too!")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Use a sand filter!")
			await scienceguy.set_text("Sand filters clean out the dirt in water.")
		4:
			scienceguy.set_sprite(scienceguy.Sprite.EVIL)
			await scienceguy.set_text("Muahaha...")
			await scienceguy.set_text("Try and stop THIS, hero...")
			scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
			await scienceguy.set_text("Oh no!")
			await scienceguy.set_text("The dirt is being taken away by the river...")
			scienceguy.set_sprite(scienceguy.Sprite.EVIL)
			await scienceguy.set_text("The RIVER is ERODING!")
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("Luckily, plants' roots can stop eroding!")
			await scienceguy.set_text("Click on a sandy riverbank.")
			if has_node("Minigames/PlantMinigame"):
				toggle_dialogue(false)
				await $Minigames/PlantMinigame.unpaused
				toggle_dialogue(true)
				scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
				await scienceguy.set_text("Use our gardening tools to plant a plant.")
				await scienceguy.set_text("Drag the tools and wiggle them around!")
				scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
				await scienceguy.set_text("Be quick!")
		5:
			scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
			await scienceguy.set_text("I'm proud of you.")
			await scienceguy.set_text("You've done a great job.")
			scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
			await scienceguy.set_text("This is the final level...")
			await scienceguy.set_text("It's hard, but I believe you can do it!")
			if has_node("Minigames/TrashMinigame"):
				toggle_dialogue(false)
				await $Minigames/TrashMinigame.unpaused
				toggle_dialogue(true)
				await scienceguy.set_text("The compost bin is for old food.")
	
	toggle_dialogue(false)


func toggle_dialogue(value: bool) -> void:
	scienceguy.visible = value
	fade_grid(value)


func _on_next_level_pressed() -> void:
	get_tree().reload_current_scene()


func _on_world_map_pressed() -> void:
	Save.change_scene("res://scenes/worldmap/worldmap.tscn")
