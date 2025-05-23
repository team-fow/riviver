class_name Minigame ## The base class for minigames. Overwrite with more specific functionality
extends Node2D

signal started(minigame: Minigame) ## Emitted when the minigame begins.
signal unpaused ## Emitted when the minigame is unpaused.
signal ended(minigame: Minigame, score: float) ## Emitted when the minigame is completed and passes the score to the level.

var score: float: ## How well the minigame was played, on a scale from 0 to 1.
	set(value): score = clampf(value, 0.0, 1.0)
var pointer: PointerTutorial ## The level pointer node
var is_completed: bool = false

@onready var level: Level = $"../../" ## The level that this minigame is a part of


## Runs when the minigame starts. Overwrite.
func start() -> void:
	started.emit(self)


## Pauses or unpauses the minigame.
func set_paused(paused: bool) -> void:
	visible = not paused
	process_mode = PROCESS_MODE_DISABLED if paused else PROCESS_MODE_ALWAYS
	if not paused: unpaused.emit()



# virtual

func _ready() -> void:
	set_paused(true)
