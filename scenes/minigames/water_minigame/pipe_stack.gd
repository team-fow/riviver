class_name PipeStack
extends Node2D

var pipes_in_stack: int
@onready var label: Label = $Label


func add_pipe(pipe: Pipe) -> void:
	if pipe.is_inside_tree():
		pipe.reparent(self)
	else:
		add_child(pipe)


func _on_child_order_changed() -> void:
	var pipe_children : Array[Node] = get_children().filter(func(child): return child is Pipe)
	pipes_in_stack = pipe_children.size()
	label.text = str(pipes_in_stack)
	if pipes_in_stack == 0:
		self.hide()
	else:
		self.show()
		for child in pipe_children:
			if child == pipe_children[0]: child.input_pickable = true
			else: child.input_pickable = false
		
