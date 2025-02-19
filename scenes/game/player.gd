class_name Player
extends Node
## Manages player cards & materials.

enum MaterialType {
	TRASH,
	FOOD,
	LUMBER,
	ENERGY,
	RAINDROPS,
}

var materials: Array[MaterialType] ## List of material counts. Index with MaterialType.



# virtual

func _init() -> void:
	materials.resize(MaterialType.size())
