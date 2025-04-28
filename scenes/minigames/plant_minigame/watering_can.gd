extends Tool


func _grab() -> void:
	super()
	$Sprite.play("pour")


func _drop() -> void:
	super()
	$Sprite.play("default")
