class_name TileCardInfo
extends CardInfo


@export var recipe_keys: Array[Tile.Type]
@export var recipe_vals: Array[Tile.Type]
@export var radius: float
var recipes: Dictionary


# Plays the card, converting the targetted tile into a tile of the result type
func play(target: Tile):
	target._set_type(recipe_vals[recipe_keys.find(target.type)])
	Game.grid.radiate_effect(target, func (t): t._set_type(recipe_vals[recipe_keys.find(target.type)]), Tile.is_type.bind(recipe_keys), radius ** 2)


# Determines whether the card can be played on a certain tile and returns a bool
func can_be_played(target: Tile) -> bool:
	return target.type in recipe_keys
