extends Camera2D

const SCREEN_MARGIN: float = 150.0
const SPEED: int = 250
const ACCEL: float = 0.1

var pull: Vector2



# movement

func _process(delta: float) -> void:
	position = position + pull * delta


## Sets whether the camera can be moved.
func set_movable(value: bool) -> void:
	set_process_unhandled_input(value)
	set_process(value)
	pull = Vector2.ZERO



# cursor control

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#var screen_center: Rect2 = get_viewport_rect().grow(-SCREEN_MARGIN)
		#if screen_center.has_point(event.global_position):
			#pull = Vector2.ZERO
		#else:
			#pull = screen_center.get_center().direction_to(event.global_position) * SPEED
#
#
#func _ready() -> void:
	#get_window().mouse_exited.connect(set_movable.bind(false))
	#get_window().mouse_entered.connect(set_movable.bind(true))



# keyboard control

func _unhandled_key_input(_event: InputEvent) -> void:
	pull = Input.get_vector("move_left", "move_right", "move_up", "move_down") * SPEED
