class_name Pipe
extends Draggable

enum DIRECTIONS {UP, DOWN, LEFT, RIGHT}
@export var holes: Array[DIRECTIONS]
@export var is_filter: bool
var texture: Texture2D = preload("res://icon.svg") 

@onready var sprite_2d: Sprite2D = $Sprite2D
const SIZE: Vector2 = Vector2(50.0, 50.0)


# Functions for identifying the behavior of a pipe from a string identifier and vice-versa
static func directions_to_string(directions: Array[DIRECTIONS]) -> String:
	var output: String = ""
	for dir in directions:
		match dir:
			DIRECTIONS.UP: output += "UP"
			DIRECTIONS.DOWN: output += "DOWN"
			DIRECTIONS.LEFT: output += "LEFT"
			DIRECTIONS.RIGHT: output += "RIGHT"
	return output
	

static func string_to_directions(s : String) -> Array[DIRECTIONS]:
	var output: Array[DIRECTIONS]
	while not s.is_empty():
		if s.containsn("UP"): 
			output.append(DIRECTIONS.UP)
			s = s.replacen("UP","")
		elif s.containsn("DOWN"): 
			output.append(DIRECTIONS.DOWN)
			s = s.replacen("DOWN","")
		elif s.containsn("LEFT"): 
			output.append(DIRECTIONS.LEFT)
			s = s.replacen("LEFT","")
		elif s.containsn("RIGHT"): 
			output.append(DIRECTIONS.RIGHT)
			s = s.replacen("RIGHT","")
		else:
			s = ""
	return output
	

static func flip_direction(dir: DIRECTIONS) -> DIRECTIONS:
	match dir:
		DIRECTIONS.UP: return DIRECTIONS.DOWN
		DIRECTIONS.DOWN: return DIRECTIONS.UP
		DIRECTIONS.LEFT: return DIRECTIONS.RIGHT
		_: return DIRECTIONS.LEFT
		
		
static func dir_to_vector(dir: DIRECTIONS) -> Vector2i:
	match dir:
		DIRECTIONS.UP: return Vector2i(0,-1)
		DIRECTIONS.DOWN: return Vector2i(0,1)
		DIRECTIONS.LEFT: return Vector2i(-1,0)
		_: return Vector2i(1,0)


# Returns a pipe object given a string decriptor
static func create_pipe(s : String) -> Pipe:
	var new_pipe: Pipe = load("res://Scenes/minigames/water_minigame/pipes/pipe.tscn").instantiate()
	new_pipe.texture = WaterMinigame.get_texture(s)
	new_pipe.is_filter = s.containsn("FILTER")
	new_pipe.holes = Pipe.string_to_directions(s) 
	return new_pipe


func _ready() -> void:
	super()
	sprite_2d.texture = texture
