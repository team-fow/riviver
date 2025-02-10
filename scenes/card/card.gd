class_name Card
extends Control

@export var card_res: CardData
var card_script: CardBehavior

@onready var background: TextureRect = $Background
@onready var card_name: Label = $Margin/Info/CardName
@onready var art: TextureRect = $Margin/Info/Art
@onready var description: Label = $Margin/Info/Description


func _ready() -> void:
	background.texture = card_res.background
	card_name.text = card_res.name
	art.texture = card_res.art
	description.text = card_res.description
	card_script = card_res.card_script
	
	
func play(game_node : Node) -> void:
	card_script.play(game_node)
