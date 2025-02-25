class_name Player
extends Node
## Manages player cards & materials.

signal material_amount_changed(type: MaterialType)
signal material_max_amount_changed(type: MaterialType)

enum MaterialType {
	TRASH,
	FOOD,
	LUMBER,
	ENERGY,
	RAINDROPS,
}

var _material_amounts: PackedInt32Array # List of material counts. Index with MaterialType.
var _material_max_amounts: PackedInt32Array # List of max material counts. Index with MaterialType.
@onready var hand: Hand = $HandLayer/Hand


# material

## Increases the amount of some material type.
func add_material(type: MaterialType, amount: int) -> void:
	_material_amounts[type] += amount
	material_amount_changed.emit(type)


## Returns the amount of some material type.
func count_material(type: MaterialType) -> int:
	return _material_amounts[type]


## Increases the maximum amount of some material type.
func add_max_material(type: MaterialType, amount: int) -> void:
	_material_max_amounts[type] += amount
	material_max_amount_changed.emit(type)


## Returns the maximum amount of some material type.
func count_max_material(type: MaterialType) -> int:
	return _material_max_amounts[type]



# virtual

func _init() -> void:
	_material_amounts.resize(MaterialType.size())
	_material_max_amounts.resize(MaterialType.size())
