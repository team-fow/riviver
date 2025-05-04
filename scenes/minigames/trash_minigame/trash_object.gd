class_name TrashObject ## The objects on the grid for the Trash Minigame
extends Draggable

signal eaten ## Emitted when the trash object is dropped into a trashcan

@export_enum("landfill", "recycling", "compost", "hazardous") var category: String = "landfill" ## Which bin the trash belongs in

var type: int ## Which texture the trash object uses
@onready var initial_scale: Vector2 = scale
@export var minigame: TrashMinigame ## The minigame containing the trashcans for the trash object to be dropped in


## Is called when the trash object is dropped (reference Draggable)
func _drop() -> void:
	var params := PhysicsPointQueryParameters2D.new()
	params.collide_with_areas = true
	params.position = global_position
	var collisions := get_world_2d().direct_space_state.intersect_point(params)
	for collision: Dictionary in collisions:
		if collision.collider is TrashBin:
			collision.collider.eat(self)
			eaten.emit()
			queue_free()
			break


func _mouse_enter() -> void:
	scale = initial_scale * 1.2


func _mouse_exit() -> void:
	scale = initial_scale


func _ready() -> void:
	super()
	# Sets the texture for the trash object randomly
	$Sprite.texture = load("res://assets/minigames/trash/%s_trash.png" % category)
	$Sprite.hframes = {"landfill": 3, "recycling": 8, "compost": 6, "hazardous": 4}[category]
	$Sprite.frame = randi() % $Sprite.hframes
	type = $Sprite.frame
