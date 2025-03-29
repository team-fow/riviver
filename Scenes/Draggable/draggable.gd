class_name Draggable # The base class for draggable nodes - requires a collision shape as a child node 
extends Area2D

signal grabbed
signal dropped

var held: bool = false
var hovered: bool = false
var curr_tween: Tween


# Handles clicking and dragging
func _unhandled_input(event: InputEvent) -> void:
	if held:
		if event is InputEventMouseMotion:
			global_position = get_global_mouse_position()
			var mouse_velocity_x: float = event.screen_velocity.x
			if curr_tween: curr_tween.kill()
			curr_tween = get_tree().create_tween()
			curr_tween.tween_property(self, "rotation_degrees", mouse_velocity_x*9.0/100.0, 0.1)
		elif event.is_action_released("click"):
			if curr_tween: curr_tween.kill()
			curr_tween = get_tree().create_tween()
			curr_tween.tween_property(self, "rotation_degrees", 0, 0.05)
			drop()
	else:
		if event.is_action_pressed("click") && hovered:
			grab()


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
