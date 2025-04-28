extends Control

signal next

enum Sprite {
	FRUSTRATED,
	HAPPY,
	ANGRY,
	EVIL,
	EVIL_SCARED,
}

var is_evil: bool

@onready var animator: AnimationPlayer = $Animator


func set_sprite(value: Sprite) -> void:
	is_evil = value >= Sprite.EVIL
	match value:
		Sprite.FRUSTRATED: $Sprite.texture = preload("res://assets/sceinceguy/science_guy_frustrated.png")
		Sprite.HAPPY: $Sprite.texture = preload("res://assets/sceinceguy/science_guy_happy.png")
		Sprite.ANGRY: $Sprite.texture = preload("res://assets/sceinceguy/science_guy_angry.png")
		Sprite.EVIL: $Sprite.texture = preload("res://assets/evil.png")
		Sprite.EVIL_SCARED: $Sprite.texture = preload("res://assets/evil_scared.png")
	animator.play("bob_sprite")


func set_text(text: String) -> void:
	$Label.text = text
	if text.begins_with("NOO"):
		$PollutoNo.play()
	else:
		($VoicePolluto if is_evil else $VoiceFurrero).play()
	await next


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		next.emit()


func _on_visibility_changed() -> void:
	$Layer.visible = visible
