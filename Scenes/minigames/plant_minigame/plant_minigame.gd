extends Minigame

@export_range(1, 3) var plant_count: int = 1
var plants_grown: int

var tools: Array[Area2D]
var held_tool: Area2D

var plants: Array[Area2D]

@onready var background: ColorRect = $Background


func _ready() -> void:
	# setting up tools
	for tool: Area2D in $Tools.get_children():
		tools.append(tool)
	# adding plants
	for i: int in plant_count:
		var plant: Area2D = preload("res://scenes/minigames/plant_minigame/plant.tscn").instantiate()
		plant.position.x = background.position.x + background.size.x / plant_count * (i + 0.5)
		plant.grown.connect(_on_plant_grown)
		plants.append(plant)
		$Plants.add_child(plant)


func _on_plant_grown() -> void:
	plants_grown += 1
	
	if plants_grown == plant_count:
		ended.emit(self, 1.0)
