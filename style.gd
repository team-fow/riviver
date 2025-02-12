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

var _private_variable: Variant ## prefix private variables with _

@onready var onready_variable: Node ## documentation


## documentation
func public_function(parameter: Variant) -> void: # public functions come first
	pass


## documentation
func _private_function(parameter: Variant) -> void: # prefix private functions with _
	pass


## documentation
func _set_variable_with_setter(value: Variant) -> void: # name setters _set_[variable name]
	variable_with_setter = value


## documentation
func _get_variable_with_getter() -> Variant: # name getters _get_[variable name]
	return "hi!"


## documentation
func _on_signal_1() -> void: # name signal connections _on_[signal name]
	print("signal_1 emitted!")



# virtual

func _ready() -> void: # _ready and other virtuals go down here
	pass
