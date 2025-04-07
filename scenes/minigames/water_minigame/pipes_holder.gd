class_name PipeHolder
extends Node2D

const SEPARATION: float = Pipe.SIZE.x
const TWEEN_DURATION: float = 0.1

var tween: Tween
var pipes: Array[PipeStack]
var held_pipe: Pipe
var held_pipe_id: int

	
func create_or_add_to_stack(pipe: Pipe) -> bool:
	var pipename: String = Pipe.directions_to_string(pipe.holes) + pipe.filter_type
	for child: Node in get_children():
		if child.name == pipename:
			child.add_pipe(pipe)
			pipe.grabbed.connect(func(): pipe.reparent(self))
			await order_pipes()
			return true
	var new_stack: PipeStack = load("res://scenes/minigames/water_minigame/pipe_stack.tscn").instantiate()
	new_stack.name = pipename
	add_child(new_stack)
	pipes.insert(0, new_stack)
	new_stack.child_order_changed.connect(func(): await order_pipes)
	new_stack.add_pipe(pipe)
	pipe.grabbed.connect(func(): pipe.reparent(self))
	await order_pipes()
	return false
	
	
func order_pipes() -> void:
	for pipe_stack: PipeStack in pipes:
		var stacksize: int = pipe_stack.pipes_in_stack
		if stacksize == 0:
			pipes.erase(pipe_stack)
			pipe_stack.queue_free()
	var width: float = SEPARATION * (pipes.size() - 1)
	var left: float = -width / 2.0
	if pipes.size() == 1:
		tween_stack(pipes[0], Vector2(0, 0), 0)
	elif pipes.size() > 1:
		var half_count: float = (pipes.size() - 1) / 2.0
		for i: int in pipes.size():
			var percent: float = (i - half_count) / half_count
			tween_stack(
				pipes[i],
				Vector2(left + SEPARATION * i, 0),
				0
			)


func tween_stack(pipe: PipeStack, pos: Vector2, rot: float) -> void:
	tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(pipe, "position", pos, TWEEN_DURATION)
	tween.tween_property(pipe, "rotation", rot, TWEEN_DURATION)
	await tween.finished
