extends Minigame

@export_range(1, 3) var plant_count: int = 1
var plants_grown: int

var tools: Array[Tool]
var held_tool: Tool

var plants: Array[Area2D]

@onready var background: Control = $Background
@onready var timer_label: Label = $Background/TimerLabel
@onready var timer: Timer = $Timer


func _ready() -> void:
	# setting up tools
	for tool: Tool in $Tools.get_children():
		tools.append(tool)
	# adding plants
	for i: int in plant_count:
		var plant: Area2D = preload("res://scenes/minigames/plant_minigame/plant.tscn").instantiate()
		plant.position.x = background.position.x + 50 + (background.size.x - 50) / plant_count * (i + 0.5)
		plant.grown.connect(_on_plant_grown)
		plants.append(plant)
		$Plants.add_child(plant)


func _on_plant_grown() -> void:
	plants_grown += 1
	if plants_grown == plant_count: end()


func end() -> void:
	var total_score: float
	for plant: PlantMinigamePlant in plants:
		total_score += float(plant.state) / PlantMinigamePlant.State.WATERED
	score = total_score / plants.size()
	await get_tree().create_timer(1.0).timeout
	ended.emit(self, score)



# timer

func start() -> void:
	super()
	timer.start()


func _process(_delta: float) -> void:
	timer_label.text = str(roundf(timer.time_left))


func _on_timeout() -> void:
	end()
