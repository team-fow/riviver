class_name PointerTutorial
extends Sprite2D

var tween: Tween


func tutorial_point(pos_a: Vector2, pos_b: Vector2, shake: bool = false) -> void:
	if tween != null: 
		tween.kill()
		modulate = Color(1.0,1.0,1.0,0.0)
	global_position = pos_a
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	await tween.finished
	
	await get_tree().create_timer(0.1).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", pos_b, 0.75)
	await tween.finished
	
	await get_tree().create_timer(0.1).timeout
	
	if shake:
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", pos_b + Vector2(40, 0), 0.04)
		await tween.finished
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", pos_b + Vector2(-40, 0), 0.08)
		await tween.finished
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", pos_b, 0.02)
		await tween.finished
		await get_tree().create_timer(0.1).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,0.0), 0.1)
	await tween.finished
