class_name PipeHolder
extends Node2D

const SEPARATION: float = Pipe.SIZE.x - 8
const TWEEN_DURATION: float = 0.1

var tween: Tween
var pipes: Array[Pipe]
var held_pipe: Pipe
var held_pipe_id: int


func add_pipe(new_pipe: Pipe, id: int = 0) -> void:
	if new_pipe.is_inside_tree():
		new_pipe.reparent(self)
	else:
		add_child(new_pipe)
	move_child(new_pipe, id)
	pipes.insert(id, new_pipe)
	new_pipe.dropped.connect(order_pipes)
	await order_pipes()
	
	
func order_pipes() -> void:
	var width: float = SEPARATION * (pipes.size() - 1)
	var left: float = -width / 2.0
	if pipes.size() == 1: # displaying single card
		tween_pipe(pipes[0], Vector2(0, 0), 0)
	elif pipes.size() > 1: # fanning multiple cards
		var half_count: float = (pipes.size() - 1) / 2.0
		for i: int in pipes.size():
			var percent: float = (i - half_count) / half_count
			tween_pipe(
				pipes[i],
				Vector2(left + SEPARATION * i, 0),
				0
			)


func tween_pipe(pipe: Pipe, pos: Vector2, rot: float) -> void:
	tween = get_tree().create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(pipe, "position", pos, TWEEN_DURATION)
	tween.tween_property(pipe, "rotation", rot, TWEEN_DURATION)
	await tween.finished
