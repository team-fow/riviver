class_name Hand
extends Node2D

const TWEEN_DURATION: float = 0.1 ## Duration of tweening effects.
const CARD_SEPARATION: float = Card.SIZE.x * 1.25 ## Horizontal spacing between cards.
const MAX_FAN_ROTATION: float = 0 ## Maximum rotation for fanning.
const MAX_FAN_OFFSET: float = 0 ## Maximum vertical offset for fanning.
const HOVERED_CARD_SCALE := Vector2(1.2, 1.2) ## Scaling applied to the currently hovered card.
const HIGHLIGHT_COLOR := Color("#ddffbb") ## Highlight applied to playable tiles.

var cards: Array[Card] ## All cards stored in this list.
var tween: Tween
var held_card: Card ## The card currently being dragged out of the hand.
var held_card_idx: int ## The previous index of [member held_card] in the list.
var hovered_tile: Tile
var retracted = false


func _ready() -> void:
	add_card("worldtree")
	add_card("growth")
	add_card("fertilizer")
	add_card("erosion")
	add_card("sedimentation")
	add_card("fish")
	add_card("rain")
	add_card("storm")

# modifying list

## Adds a card at index [member idx].
func add_card(key: String, idx: int = -1) -> void:
	var card: Card = preload("res://scenes/card/card.tscn").instantiate()
	card.info = ResourceLibrary.get_card(key)
	
	if card.is_inside_tree():
		card.reparent(self)
	else:
		add_child(card)
	
	move_child(card, idx)
	_add_card_to_list(card, idx)
	await card.tween.finished
	card.gui_input.connect(_on_card_input.bind(card))
	card.mouse_entered.connect(_on_card_moused.bind(card, true))
	card.mouse_exited.connect(_on_card_moused.bind(card, false))


## Removes a card.
func remove_card(card: Card) -> void:
	_remove_card_from_list(card)
	if card.tween: card.tween.kill()
	card.gui_input.disconnect(_on_card_input)
	card.mouse_entered.disconnect(_on_card_moused)
	card.mouse_exited.disconnect(_on_card_moused)
	card.scale = Vector2.ONE
	

# Adds a card to cards at index idx. Does not add it as a child.
func _add_card_to_list(card: Card, idx: int) -> void:
	if idx == -1:
		cards.append(card)
	else:
		cards.insert(idx, card)
	_order_cards()
	card.set_input(true)
	
	
# Removes a card from cards. Does not remove it as a child.
func _remove_card_from_list(card: Card) -> void:
	cards.erase(card)
	_order_cards()
	card.set_input(false)
	card.rotation = 0
	
	
# display


func _order_cards() -> void:
	var width: float = CARD_SEPARATION * (cards.size() - 1)
	var left: float = -width / 2.0
	
	var vertical_offset: float = Card.SIZE.y/8
	var hand_tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	if held_card != null and not retracted:
		retracted = true
		hand_tween.tween_property(self, "position", Vector2(position.x, position.y+vertical_offset),TWEEN_DURATION)
	else:
		retracted = false
		hand_tween.tween_property(self, "position", Vector2(position.x, position.y-vertical_offset),TWEEN_DURATION)
	if cards.size() == 1: # displaying single card
		_tween_card(cards[0], Vector2(0, MAX_FAN_OFFSET), 0)
	
	elif cards.size() > 1: # fanning multiple cards
		var half_count: float = (cards.size() - 1) / 2.0
		for i: int in cards.size():
			var percent: float = (i - half_count) / half_count
			_tween_card(
				cards[i],
				Vector2(left + CARD_SEPARATION * i, abs(percent) * MAX_FAN_OFFSET),
				percent * MAX_FAN_ROTATION
			)
			
	
# Smoothly animates positioning and rotating a card.
func _tween_card(card: Card, pos: Vector2, rot: float) -> void:
	tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	card.tween = tween
	tween.tween_property(card, "position", pos, TWEEN_DURATION)
	tween.tween_property(card, "rotation", rot, TWEEN_DURATION)
	await tween.finished
	card.tween = null
	
	
func _on_card_moused(card: Card, mouse_inside: bool) -> void:
	if not held_card:
		card.z_index = mouse_inside
		card.scale = HOVERED_CARD_SCALE if mouse_inside else Vector2.ONE
		
		if mouse_inside:
			_tween_card(card, card.position, 0)
		elif cards.size() > 1:
			var half_count: float = (cards.size() - 1) / 2.0
			var percent: float = (cards.find(card) - half_count) / half_count
			_tween_card(card, card.position, percent * MAX_FAN_ROTATION)
	
	
# grabbing cards

# Handles grabbing cards.
func _on_card_input(event: InputEvent, card: Card) -> void:
	if event.is_action_pressed("click"):
		held_card = card
		held_card_idx = cards.find(held_card)
		_remove_card_from_list(card)
		highlight_playable(held_card)


# Handles dragging/dropping the held card.
# If the card is dropped in drop_area, reinserts the card into the list; otherwise, plays the card.
func _unhandled_input(event: InputEvent) -> void:
	if held_card:
		if event is InputEventMouseMotion:
			held_card.accept_event()
			var grid_coords: Vector2i = Grid.point_to_coords(Game.grid.get_local_mouse_position())
			hovered_tile = Game.grid.get_tile(grid_coords)
			held_card.position = get_local_mouse_position()
		
		elif event.is_action_released("click"):
			held_card.accept_event()
			var grid_coords: Vector2i =  Grid.point_to_coords(Game.grid.get_local_mouse_position())
			hovered_tile = Game.grid.get_tile(grid_coords)
			
			if get_local_mouse_position().y > -Card.SIZE.y/2 or get_tree().current_scene.get_local_mouse_position().length() > 400:
				_add_card_to_list(held_card, held_card_idx)
			else:
				var can_play = held_card.info.can_be_played(hovered_tile)
				if can_play:
					held_card.play(hovered_tile)
					remove_card(held_card)
					held_card.queue_free()
				else:
					_add_card_to_list(held_card, held_card_idx)
			
			unhighlight_playable(held_card)
			held_card = null



# highlighting

## Highlights all visible tiles a card can be played on in some color.
func highlight_playable(card: Card) -> void:
	var start: Vector2i = Game.grid.get_chunk(Game.camera.chunk_coords - Vector2i.ONE).tile_offset
	for x: int in Chunk.SIZE.x * 3:
		for y: int in Chunk.SIZE.y * 3:
			var tile: Tile = Game.grid.get_tile(start + Vector2i(x, y))
			if tile and card.info.can_be_played(tile):
				Game.grid.add_highlight(tile.coords, HIGHLIGHT_COLOR)

## Unhighlights all visible tiles.
func unhighlight_playable(card: Card) -> void:
	var start: Vector2i = Game.grid.get_chunk(Game.camera.chunk_coords - Vector2i.ONE).tile_offset
	for x: int in Chunk.SIZE.x * 3:
		for y: int in Chunk.SIZE.y * 3:
			Game.grid.remove_highlight(start + Vector2i(x, y))
