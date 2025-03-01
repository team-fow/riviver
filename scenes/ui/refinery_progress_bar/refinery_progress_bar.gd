extends Node2D

signal looped

@onready var radial: TextureProgressBar = $Radial


func set_duration(value: float) -> void:
	radial.max_value = value


func _process(delta: float) -> void:
	if radial.value + delta > radial.max_value:
		radial.value = 0
		looped.emit()
	radial.value += delta
