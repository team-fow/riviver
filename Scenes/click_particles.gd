extends GPUParticles2D


func _ready() -> void:
	amount = randi_range(1, 2)
	emitting = true


func set_type(source_id: int, tile_id: Vector2i) -> void:
	if source_id == 6:
		set_type_by_name("water")
	elif source_id == 7 and (tile_id == Vector2i(3, 1) or tile_id.x > 1 and tile_id.y > 1):
		set_type_by_name("dirt")
	else:
		set_type_by_name("grass")


func set_type_by_name(key: String) -> void:
	match key:
		"water":
			texture = preload("res://assets/particles/particle-water.png")
			material.particles_anim_h_frames = 3
		"dirt":
			texture = preload("res://assets/particles/particle-dirt.png")
			material.particles_anim_h_frames = 3
		"grass":
			texture = preload("res://assets/particles/particle-leaves.png")
			material.particles_anim_h_frames = 2




func _on_finished() -> void:
	queue_free()
