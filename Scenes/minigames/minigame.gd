class_name Minigame
extends Node2D

signal started(minigame: Minigame) ## Emitted when the minigame begins.
signal ended(minigame: Minigame, score: float) ## Emitted when the minigame is completed.

var score: float: ## How well the minigame was played, on a scale from 0 to 1.
	set(value): score = clampf(value, 0.0, 1.0)


## Runs when the minigame starts. Overwrite.
func start() -> void:
	started.emit(self)
	prints("started minigame:", name)


## Pauses or unpauses the minigame.
func set_paused(paused: bool) -> void:
	visible = not paused
	process_mode = PROCESS_MODE_DISABLED if paused else PROCESS_MODE_ALWAYS



# virtual

func _ready() -> void:
	set_paused(true)
