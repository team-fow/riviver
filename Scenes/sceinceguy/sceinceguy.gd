extends Control

signal next

enum Sprite {
	FRUSTRATED,
	HAPPY,
}



func set_sprite(value: Sprite) -> void:
	match value:
		Sprite.FRUSTRATED: $Sprite.texture = load("res://assets/sceinceguy/science_guy_frustrated.png")
		Sprite.HAPPY: $Sprite.texture = load("res://assets/sceinceguy/science_guy_happy.png")


func set_text(text: String) -> void:
	$Label.text = text
	await next


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		next.emit()
