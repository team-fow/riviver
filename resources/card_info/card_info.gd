class_name CardInfo
extends Resource

@export var name: String
@export var material: Player.MaterialType
@export var material_cost: int
@export var art: Texture2D
@export_multiline var text: String


func play(target: Tile) -> void:
	pass


# Determines whether the card can be played on a certain tile and returns a bool. Is overwritten in extensions
func can_be_played(target: Tile) -> bool:
	return true
