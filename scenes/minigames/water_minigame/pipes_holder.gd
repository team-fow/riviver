class_name PipeHolder
extends ScrollContainer

var SEPARATION: float = Pipe.SIZE.x * PipeStack.SCALE.x + 10
const TWEEN_DURATION: float = 0.1
@onready var h_box_container: HBoxContainer = $HBoxContainer

var tween: Tween
var pipes: Array[PipeStack]
var held_pipe: Pipe
var held_pipe_id: int
var minigame: WaterMinigame

	
func create_or_add_to_stack(pipe: Pipe) -> bool:
	var pipename: String = Pipe.directions_to_string(pipe.holes) + pipe.filter_type
	for child: Node in h_box_container.get_children():
		if child.name == pipename:
			child.add_pipe(pipe)
			pipe.grabbed.connect(func(): pipe.reparent(minigame))
			await order_pipes()
			return true
	var new_stack: PipeStack = load("res://scenes/minigames/water_minigame/pipe_stack.tscn").instantiate()
	new_stack.name = pipename
	h_box_container.add_child(new_stack)
	pipes.insert(0, new_stack)
	new_stack.child_order_changed.connect(func(): await order_pipes)
	new_stack.add_pipe(pipe)
	pipe.grabbed.connect(func(): pipe.reparent(minigame))
	await order_pipes()
	return false
	
	
func order_pipes() -> void:
	pass
	for pipe_stack: PipeStack in pipes:
		var stacksize: int = pipe_stack.pipes_in_stack
		if stacksize == 0:
			pipes.erase(pipe_stack)
			pipe_stack.queue_free()


func tween_stack(pipe: PipeStack, pos: Vector2, rot: float) -> void:
	tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(pipe, "position", pos, TWEEN_DURATION)
	tween.tween_property(pipe, "rotation", rot, TWEEN_DURATION)
	await tween.finished
