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
	
	left_arrow.visible = selected_idx != 0
	right_arrow.visible = selected_idx != levels.get_child_count() - 1


## Selects the previous level sequentially.
func select_prev_level() -> void:
	select_level(selected_idx - 1)
	#Input.warp_mouse(left_arrow.get_screen_position())


## Selects the next level sequentially.
func select_next_level() -> void:
	select_level(selected_idx + 1)
	#Input.warp_mouse(right_arrow.get_screen_position())


## Opens the selected level.
func play_selected_level() -> void:
	Save.set_current_level(selected_idx)
	Save.change_scene("res://scenes/levels/%s.tscn" % str(selected_idx + 1))



# virtual

func _ready() -> void:
	select_level(Save.get_current_level())
	camera.reset_smoothing()
	
	if not Save.data.get("did_intro_cutscene"):
		do_intro_cutscene()


# Keyboard navigation between levels
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		select_prev_level()
	elif event.is_action_pressed("move_right"):
		select_next_level()


func _on_settings_pressed() -> void:
	add_child(load("res://scenes/settings/settings.tscn").instantiate())


func do_intro_cutscene() -> void:
	level_info.hide()
	scienceguy.show()
	scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
	await scienceguy.set_text("Hi, I'm John Furrero! Welcome to Riviver.")
	scienceguy.set_sprite(scienceguy.Sprite.FRUSTRATED)
	await scienceguy.set_text("Our beloved river has been polluted...")
	scienceguy.set_sprite(scienceguy.Sprite.HAPPY)
	await scienceguy.set_text("Let's fix this, together!")
	scienceguy.hide()
	Save.data.did_intro_cutscene = true
	level_info.show()
