extends GPUParticles2D


func _ready() -> void:
	amount = randi_range(1, 2)
	emitting = true


func set_type(source_id: int, tile_id: Vector2i) -> void:
	# water
	if source_id in [0, 4, 5]:
		texture = preload("res://assets/particles/particle-leaves.png")
		material.particles_anim_h_frames = 2
	# sand
	elif source_id == 7 and (tile_id == Vector2i(3, 1) or tile_id.x > 1 and tile_id.y > 1):
		texture = preload("res://assets/particles/particle-leaves.png")
		material.particles_anim_h_frames = 2
	# grass
	else:
		texture = preload("res://assets/particles/particle-leaves.png")
		material.particles_anim_h_frames = 2




func _on_finished() -> void:
	queue_free()
