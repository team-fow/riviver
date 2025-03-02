extends CardInfo

@export var amount: int


# Plays the card, converting the targetted tile into a tile of the result type
func play(target: Tile):
	Game.river.fish += amount


# Determines whether the card can be played on a certain tile and returns a bool
func can_be_played(target: Tile) -> bool:
	return Tile.has_tag(target, "river")
