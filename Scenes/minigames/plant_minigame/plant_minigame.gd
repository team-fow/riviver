extends Minigame

const PLANT_SEPARATION: float = 400.0

@export_range(1, 3) var plant_count: int = 1
var plants_grown: int

var tools: Array[Tool]
var held_tool: Tool

var plants: Array[Area2D]

@onready var background: Control = $Background
@onready var water: TextureRect = $Background/Water
@onready var timer_label: Label = $Background/TimerLabel
@onready var timer: Timer = $Timer
@onready var animator: AnimationPlayer = $Animator


func _ready() -> void:
	# setting up tools
	for tool: Tool in $Tools.get_children():
		tools.append(tool)
	# adding plants
	for i: int in plant_count:
		var plant: Area2D = preload("res://scenes/minigames/plant_minigame/plant.tscn").instantiate()
		plant.position.x = PLANT_SEPARATION * i
		plant.grown.connect(_on_plant_grown)
		plants.append(plant)
		$Plants.add_child(plant)
	$Plants.position.x = (plant_count - 1) * PLANT_SEPARATION * -0.5
	

func _on_plant_grown() -> void:
	plants_grown += 1
	if plants_grown == plant_count: end()


func end() -> void:
	var total_score: float
	for plant: PlantMinigamePlant in plants:
		total_score += float(plant.state) / PlantMinigamePlant.State.WATERED
	score = total_score / plants.size()
	
	animator.play("water")
	await animator.animation_finished
	ended.emit(self, score)


func change_texture() -> void:
	if score < 0.75:
		water.texture = preload("res://assets/minigames/plant/eroded_river_foreground.png")
		water.pivot_offset = Vector2(500, 434.27)
		water.z_index = 1


# timer

func start() -> void:
	super()
	timer.start()


func _process(_delta: float) -> void:
	timer_label.text = str(roundi(timer.time_left)) + "s"


func _on_timeout() -> void:
	end()
