class_name CardInfo
extends Resource

@export var name: String
@export_enum("trash", "food", "rain", "lumber", "energy") var material: String
@export var material_cost: int
@export var art: Texture2D
@export_multiline var text: String
