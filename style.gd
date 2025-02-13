class_name ClassName
extends Node
## documentation

signal signal_1 ## documentation

enum Enum {
	ZERO, ## documentation
	ONE, ## documentation
	TWO, ## documentation
}

const CONSTANT: int = 0 ## documentation

@export var export_variable: int ## documentation

var public_variable: Variant ## documentation
var variable_with_setter: Variant : set = _set_variable_with_setter ## documentation
var variable_with_getter: Variant : get = _get_variable_with_getter ## documentation

var _private_variable: Variant # prefix private variables with _

@onready var onready_variable: Node ## documentation


## documentation
func public_function(parameter: Variant) -> void:
	pass


# prefix private functions with _
func _private_function(parameter: Variant) -> void:
	signal_1.connect(_on_signal_1)


# name setters _set_[variable name]
func _set_variable_with_setter(value: Variant) -> void:
	variable_with_setter = value


# name getters _get_[variable name]
func _get_variable_with_getter() -> Variant:
	return "hi!"


# name signal connections _on_[signal name]
func _on_signal_1() -> void:
	print("signal_1 emitted!")



# virtual

func _ready() -> void: # _ready and other virtuals go down here
	pass
