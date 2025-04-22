class_name PointerTutorial
extends Sprite2D

var tween: Tween


func tutorial_point(pos_a: Vector2, pos_b: Vector2) -> void:
	global_position = pos_a
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", pos_b, 1)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,0.0), 0.1)
	await tween.finished
