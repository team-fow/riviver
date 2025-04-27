extends Area2D

@export_multiline var description: String = "Description"

var locked: bool = true

@onready var sprite: Sprite2D = $Sprite
@onready var stars: Node2D = $Stars


func _ready() -> void:
	var idx: int = get_index()
	if Save.is_level_unlocked(idx):
		locked = false
		sprite.frame = 1
		if Save.is_level_completed(idx):
			sprite.frame = 2
	
	var score: float = Save.get_level_score(idx)
	for i: int in stars.get_child_count():
		stars.get_child(i).frame = 1 if score >= (i + 1) / 3.0 else 0


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		$"../../".select_level(get_index())
		get_viewport().set_input_as_handled()


func flick() -> void:
	$Animator.stop()
	$Animator.play("flick")


func _mouse_enter() -> void:
	sprite.scale = Vector2.ONE * 1.05


func _mouse_exit() -> void:
	sprite.scale = Vector2.ONE
