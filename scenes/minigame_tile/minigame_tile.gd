extends Area2D
## Minigame tile.
## Triggers a minigame when clicked; disappears when the minigame is completed.
## Add your own sprites.

signal clicked

@export var minigame: Minigame ## Minigame to trigger when this node is clicked.


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		minigame.start()
		clicked.emit()


func _ready() -> void:
	minigame.ended.connect(queue_free.unbind(2)) # frees itself when the minigame is completed
