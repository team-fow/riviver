extends Control

enum Sprite {
	FRUSTRATED,
	HAPPY,
}

@onready var label: Label = $PanelContainer/Label



func set_sprite(value: Sprite) -> void:
	match value:
		Sprite.FRUSTRATED: $Sprite.texture = load("res://assets/sceinceguy/science_guy_frustrated.png")
		Sprite.HAPPY: $Sprite.texture = load("res://assets/sceinceguy/science_guy_happy.png")


func set_text(text: String) -> void:
	label.text = text
