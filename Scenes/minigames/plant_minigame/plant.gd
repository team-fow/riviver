class_name PlantMinigamePlant
extends Area2D
## A plant in the plant minigame.

signal grown ## Emitted when the plant is fully grown.

const PROGRESS_CAP: float = 30.0

enum State { ## All states the plant can be in.
	INITIAL, ## A hole needs to be dug.
	HOLE_DUG, ## A hole has been dug. A seed needs to be planted.
	SEED_PLANTED, ## A seed has been planted. The hole needs to be filled.
	HOLE_FILLED, ## The hole has been filled. It needs to be watered.
	WATERED, ## The plant has been watered and is fully grown.
}

var state: State : set = _set_state ## Current state.
var progress: float

# Sprites...
@onready var hole_sprite: Sprite2D = $HoleSprite
@onready var seed_sprite: Sprite2D = $HoleSprite/SeedSprite
@onready var pile_sprite: Sprite2D = $PileSprite
@onready var bush_sprite: Sprite2D = $BushSprite


## Moves the plant to the next state (see the State enum).
func advance_state() -> void:
	state += 1


## Returns true if a tool can be used on the plant in its current state.
func is_affected_by_tool(tool: Area2D) -> bool:
	return state == tool.get_index()


# Called when state is set
func _set_state(value: State) -> void:
	state = value
	# showing/hiding sprites based on current state
	hole_sprite.visible = state >= State.HOLE_DUG and state < State.HOLE_FILLED
	seed_sprite.visible = state >= State.SEED_PLANTED
	pile_sprite.visible = state == State.HOLE_FILLED
	bush_sprite.visible = state >= State.WATERED
	# emitting grown signal
	if state == State.WATERED: grown.emit()



# input

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseMotion:
		var overlapping_areas: Array[Area2D] = get_overlapping_areas()
		if overlapping_areas and is_affected_by_tool(overlapping_areas[0]):
			progress += event.velocity.length() / 1000
			if progress > PROGRESS_CAP:
				advance_state()
				if overlapping_areas[0] is Tool:
					overlapping_areas[0].drop()
				progress = 0.0




# virtual

func _ready() -> void:
	state = state # updating sprites
