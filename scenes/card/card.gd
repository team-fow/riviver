class_name Card
extends Control

const SIZE := Vector2(256, 362.193)

var info: CardInfo = load("res://resources/card_info/test_card.tres") ## Info resource.
var tween: Tween
var game: Node

@onready var background: TextureRect = $Background
@onready var name_label: Label = $Margins/Info/Name
@onready var art: TextureRect = $Margins/Info/Art
@onready var description: Label = $Margins/Info/Description


## Plays the card.
func play(tile: Tile) -> void:
	info.play(tile)


# Sets whether or not the card receives mouse input
func set_input(value: bool) -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP if value else Control.MOUSE_FILTER_IGNORE


# virtual

func _ready() -> void:
	name_label.text = info.name
	background.texture = info.art
	description.text = info.text
