class_name PlantMinigamePlant
extends Area2D
## A plant in the plant minigame.

signal grown ## Emitted when the plant is fully grown.

const PROGRESS_CAP: float = 50.0

enum State { ## All states the plant can be in.
	INITIAL, ## A hole needs to be dug.
	HOLE_DUG, ## A hole has been dug. A seed needs to be planted.
	SEED_PLANTED, ## A seed has been planted. The hole needs to be filled.
	HOLE_FILLED, ## The hole has been filled. It needs to be watered.
	WATERED, ## The plant has been watered and is fully grown.
}

var state: State : set = _set_state ## Current state.

# Sprites...
@onready var hole_sprite: Sprite2D = $HoleSprite
@onready var seed_sprite: Sprite2D = $HoleSprite/SeedSprite
@onready var pile_sprite: Sprite2D = $PileSprite
@onready var bush_sprite: Sprite2D = $BushSprite
@onready var root_sprite: Sprite2D = $RootSprite

@onready var progress: HBoxContainer = $Progress
@onready var progress_bar: TextureProgressBar = $Progress/Bar
@onready var progress_icon: TextureRect = $Progress/Icon
@onready var plant_particles: GPUParticles2D = $PlantParticles


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
	root_sprite.visible = state >= State.WATERED
	# progress bar
	progress.visible = state < State.WATERED
	progress_icon.texture = [
		load("res://assets/minigames/plant/shovel.png"),
		load("res://assets/minigames/plant/seed_bag.png"),
		load("res://assets/minigames/plant/soil_bag.png"),
		load("res://assets/minigames/plant/pot_single.png"),
		null,
	][state]
	
	# emitting grown signal
	if state == State.WATERED: grown.emit()



# input

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseMotion:
		for area: Area2D in get_overlapping_areas():
			if area is Tool and is_affected_by_tool(area):
				plant_particles.texture = area.particle
				plant_particles.emitting = true
				progress_bar.value += event.velocity.length() / 1000
				if progress_bar.value == progress_bar.max_value:
					advance_state()
					progress_bar.value = 0.0




# virtual

func _ready() -> void:
	state = state # updating sprites
