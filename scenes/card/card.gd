class_name Card
extends Control

var info: CardInfo = load("res://resources/card_info/test_card.tres") ## Info resource.
var behavior: CardBehavior ## Controls effects when played.

@onready var background: TextureRect = $Background
@onready var name_label: Label = $Margins/Info/Name
@onready var art: TextureRect = $Margins/Info/Art
@onready var description: Label = $Margins/Info/Description


## Plays the card.
func play() -> void:
	if behavior: behavior.play()



# virtual

func _ready() -> void:
	name_label.text = info.name
	art.texture = info.art
	description.text = info.text
	if info.behavior: behavior = info.behavior.new(self)
