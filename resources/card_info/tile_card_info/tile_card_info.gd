class_name TileCardInfo
extends "res://resources/card_info/card_info.gd"


@export var recipe_keys: Array[Tile.Type]
@export var recipe_vals: Array[Tile.Type]
var recipes: Dictionary


# Plays the card, converting the targetted tile into a tile of the result type
func play(target: Tile):
	target._set_type(recipes[target.type])


func can_be_played(target: Tile) -> bool:
	if target.type in recipes.keys():
		return true
	else:
		return false
		

# virtual

func _init() -> void:
	for i in recipe_keys.size():
		recipes.get_or_add(recipe_keys[i], recipe_vals[i])
