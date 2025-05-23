class_name PipeStack
extends Control

const SCALE: Vector2 = Vector2(1.25, 1.25)
var pipes_in_stack: int
@onready var label: Label = $Count
@onready var tooltip: Label = $Tooltip


func add_pipe(pipe: Pipe) -> void:
	if pipe:
		if pipe.is_inside_tree():
			pipe.reparent(self)
		else:
			add_child(pipe)
			pipe.position = Vector2(97.5, 97.5)
			match pipe.filter_type:
				"SANDFILTER": tooltip.text = "Sand Filter"
				"CARBONFILTER": tooltip.text = "Carbon Filter"
				_: tooltip.text = "Pipe"
	else:
		print("Pipe not found")

func _on_child_order_changed() -> void:
	var pipe_children : Array[Node] = get_children().filter(func(child): return child is Pipe)
	pipes_in_stack = pipe_children.size()
	label.text = "x" + str(pipes_in_stack)
	if pipes_in_stack == 0:
		self.hide()
	else:
		self.show()
		for child in pipe_children:
			child.position = Vector2(97.5, 97.5)
			if child == pipe_children[0]: child.input_pickable = true
			else: child.input_pickable = false

func _ready() -> void:
	scale = SCALE


func _on_mouse_entered() -> void:
	tooltip.show()


func _on_mouse_exited() -> void:
	tooltip.hide()
