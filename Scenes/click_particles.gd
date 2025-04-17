extends GPUParticles2D


func _ready() -> void:
	amount = randi_range(1, 2)


func set_type(type: String) -> void:
	match type:
		"grass":
			texture = preload("res://assets/particles/particle-leaves.png")
			material.particles_anim_h_frames = 2
		"water":
			texture = preload("res://assets/particles/particle-leaves.png")
			material.particles_anim_h_frames = 2
