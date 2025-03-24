class_name Draggable # The base class for draggable nodes - requires a collision shape as a child node 
extends Area2D

var held: bool = false
var hovered: bool = false
const HOVERED_SCALE := Vector2(1.25, 1.25)


# Handles clicking and dragging
func _unhandled_input(event: InputEvent) -> void:
	if held:
		if event is InputEventMouseMotion:
			global_position = get_global_mouse_position()
		elif event.is_action_released("click"):
			held = false
	else:
		if event.is_action_pressed("click") && hovered:
			held = true


# Virtual
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	

func _on_mouse_entered():
	hovered = true
	

func _on_mouse_exited():
	hovered = false
