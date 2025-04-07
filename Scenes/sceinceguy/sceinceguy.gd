extends Control

signal next

enum Sprite {
	FRUSTRATED,
	HAPPY,
}

@onready var animator: AnimationPlayer = $Animator


func set_sprite(value: Sprite) -> void:
	match value:
		Sprite.FRUSTRATED: $Sprite.texture = preload("res://assets/sceinceguy/science_guy_frustrated.png")
		Sprite.HAPPY: $Sprite.texture = preload("res://assets/sceinceguy/science_guy_happy.png")
	animator.play("bob_sprite")


func set_text(text: String) -> void:
	$Label.text = text
	$Voice.play(0.0)
	await next


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		next.emit()
