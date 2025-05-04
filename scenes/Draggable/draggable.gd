class_name Draggable # The base class for draggable nodes - requires a collision shape as a child node 
extends Area2D

signal grabbed
signal dropped

var held: bool = false # Whether the node is currently being dragged by the player (should be following mouse)
var hovered: bool = false # Whether the mouse is within the bounds of the given collision shape
var curr_tween: Tween # Keeps track of the node's active tween (used for the object swinging as it is dragged around)


# Handles clicking and dragging
func _unhandled_input(event: InputEvent) -> void:
	if held:
		if event is InputEventMouseMotion: # Handles dragging the node around
			global_position = get_global_mouse_position().clamp(Vector2(-900.0, -500.0), Vector2(900.0, 500.0))
			var mouse_velocity_x: float = event.screen_velocity.x
			if curr_tween: curr_tween.kill()
			curr_tween = get_tree().create_tween()
			curr_tween.tween_property(self, "rotation_degrees", (mouse_velocity_x * 9.0)/100.0, 0.1) # Causes dragged objects to swing with mouse input
		elif event.is_action_released("click"): # Handles dropping the node
			if curr_tween: curr_tween.kill()
			curr_tween = get_tree().create_tween()
			curr_tween.tween_property(self, "rotation_degrees", 0, 0.05)
			drop()
	else:
		if event.is_action_pressed("click") && hovered: # Handles clicking the node to pick it up
			grab()
			get_viewport().set_input_as_handled()


func grab() -> void:
	held = true
	grabbed.emit()
	_grab()


func drop() -> void:
	held = false
	dropped.emit()
	_drop()



# custom virtual functions

func _grab() -> void: pass
func _drop() -> void: pass



# Virtual

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	

func _on_mouse_entered():
	hovered = true
	

func _on_mouse_exited():
	hovered = false
