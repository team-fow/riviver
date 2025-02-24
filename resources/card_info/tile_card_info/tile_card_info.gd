class_name TileCardInfo
extends "res://resources/card_info/card_info.gd"


@export var recipe_keys: Array[Tile.Type]
@export var recipe_vals: Array[Tile.Type]
@export var radius: float
var recipes: Dictionary


# Plays the card, converting the targetted tile into a tile of the result type
func play(target: Tile):
	target._set_type(recipe_vals[recipe_keys.find(target.type)])
	target.radiate_effect(func (t): t._set_type(recipe_vals[recipe_keys.find(target.type)]), radius**2, PackedInt32Array(recipe_keys))


# Determines whether the card can be played on a certain tile and returns a bool
func can_be_played(target: Tile) -> bool:
	print(target.type)
	print(recipes.keys())
	
	if target.type in recipe_keys:
		return true
	else:
		return false
		
