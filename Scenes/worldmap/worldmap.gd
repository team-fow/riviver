extends Node2D

var selected_idx: int

@onready var levels: Node2D = $Levels
@onready var camera: Camera2D = $Camera
@onready var level_name: Label = $UI/Margins/HBox/Background/Number
@onready var level_description: Label = $UI/Margins/HBox/Background/MarginContainer/LevelInfo/Description
@onready var play_button: TextureButton = $UI/Margins/HBox/Background/Play
@onready var left_arrow: TextureButton = $UI/Margins/HBox/LeftArrow
@onready var right_arrow: TextureButton = $UI/Margins/HBox/RightArrow
@onready var scienceguy: Control = $UI/Margins2/Scienceguy
@onready var level_info: HBoxContainer = $UI/Margins/HBox
@onready var mask: TextureRect = $PollutedMap/Mask
@onready var disabled_level_selector: TextureRect = $UI/Margins/HBox/Background/Disabled
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fill_particles: GPUParticles2D = $FillParticles



## Selects the level at some index in the level order.
func select_level(idx: int) -> void:
	selected_idx = clampi(idx, 0, levels.get_child_count() - 1)
	var pin: Node2D = levels.get_child(selected_idx)
	pin.flick()
	
	camera.position = pin.position + Vector2(0, 50)
	level_name.text = str(selected_idx + 1)
	level_description.text = pin.description
	
	play_button.disabled = pin.locked
	play_button.get_child(0).visible = not pin.locked
	disabled_level_selector.visible = pin.locked
	
	left_arrow.disabled = selected_idx == 0
	left_arrow.modulate.a = 0.0 if left_arrow.disabled else 1.0
	right_arrow.disabled = selected_idx == levels.get_child_count() - 1
	right_arrow.modulate.a = 0.0 if right_arrow.disabled else 1.0


## Selects the previous level sequentially.
func select_prev_level() -> void:
	select_level(selected_idx - 1)


## Selects the next level sequentially.
func select_next_level() -> void:
	select_level(selected_idx + 1)


## Opens the selected level.
func play_selected_level() -> void:
	Save.set_current_level(selected_idx)
	Save.change_scene("res://scenes/levels/%s.tscn" % str(selected_idx + 1))



# virtual

func _ready() -> void:
	var idx: int = range(levels.get_child_count()).rfind_custom(Save.is_level_completed)
	if idx == -1:
		mask.hide()
	else:
		var x: float = get_pin_x(idx - 1) if idx > 0 else 0
		mask.texture.fill_from.x = x
		fill_particles.position.x = (levels.get_child(idx - 1).position.x + 400) if idx > 0 else 0
		x = get_pin_x(idx)
		var tween := create_tween()
		tween.tween_callback(fill_particles.set_emitting.bind(true))
		tween.tween_interval(0.5)
		tween.tween_property(mask.texture, "fill_from:x", x, 1.0)
		tween.parallel().tween_property(fill_particles, "position:x", levels.get_child(idx).position.x + 400, 1.0)
		tween.tween_callback(fill_particles.set_emitting.bind(false))
	
	if not Save.data.get("did_intro_cutscene"):
		await do_intro_cutscene()
	
	if Save.is_level_completed(5) and not Save.data.get("did_outro_cutscene", false):
		await do_outro_cutscene()
	
	select_level(Save.get_current_level())
	camera.reset_smoothing()


func get_pin_x(idx: int) -> float:
	return (levels.get_child(idx).position.x + 400 - mask.get_parent().get_rect().position.x) / mask.get_parent().get_rect().size.x


# Keyboard navigation between levels
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		select_prev_level()
	elif event.is_action_pressed("move_right"):
		select_next_level()


func _on_settings_pressed() -> void:
	add_child(load("res://scenes/settings/settings.tscn").instantiate())


func do_intro_cutscene() -> void:
	$PollutedMap.modulate = Color.BLACK
	$UI/Margins.modulate.a = 0.0
	$Levels.modulate.a = 0.0
	level_info.hide()
	scienceguy.show()
	scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
	await scienceguy.set_text("Hi, I'm John Furrero! Welcome to Riviver.")
	animation_player.play("intro")
	scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
	await scienceguy.set_text("Something awful has happened...")
	scienceguy.set_sprite(scienceguy.Sprite.EVIL)
	await scienceguy.set_text("RAGHHH!!! I control the forces of pollution.")
	await scienceguy.set_text("Your precious river... is all dirty!")
	scienceguy.set_sprite(scienceguy.Sprite.ANGRY)
	await scienceguy.set_text("Help me stop this villain!")
	scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
	await scienceguy.set_text("Let's clean this river, together!")
	scienceguy.hide()
	if animation_player.is_playing():
		animation_player.speed_scale *= 3
		await animation_player.animation_finished
	Save.data.did_intro_cutscene = true
	level_info.show()


func do_outro_cutscene() -> void:
	select_level(5)
	camera.reset_smoothing()
	level_info.hide()
	scienceguy.show()
	scienceguy.set_sprite(scienceguy.Sprite.EVIL_SCARED)
	await scienceguy.set_text("Nooooo!")
	await scienceguy.set_text("The river! It's green again!")
	scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
	await scienceguy.set_text("Wow... you really did it!")
	await scienceguy.set_text("Our river is back to normal!")
	await scienceguy.set_text("You're a hero!")
	scienceguy.set_sprite(scienceguy.Sprite.EVIL)
	await scienceguy.set_text("You haven't seen the last of me, kid!")
	scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
	await scienceguy.set_text("We'll meet again someday, too. Thank you!")
	await scienceguy.set_text("Remember: keep it green!")
	scienceguy.hide()
	Save.data.did_outro_cutscene = true
	level_info.show()
