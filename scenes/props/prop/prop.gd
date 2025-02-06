class_name Prop
extends Node2D

enum Type {
	EMPTY = -1,
	FIRE,
}

static var info: Array[PropInfo]

var type: Type ## Numerical type ID.
var tile: Tile ## The [Tile] this prop is on.


## Returns a new [Prop] scene of [param type].
static func of(type: Type) -> Prop:
	var prop: Prop = info[type].scene.instantiate()
	prop.type = type
	return prop



# ticking

## Called whenever [member tile] is ticked. Overwrite this method to add custom behavior. To queue a tick, see [method Tile.queue_tick].
func _tick() -> void:
	pass



# info

# Populates [member info] with a [PropInfo] resource for each [enum Prop.Type].
static func _static_init() -> void:
	info.assign(Type.keys().slice(1).map(func(key: String) -> PropInfo: return load("res://resources/prop_info/%s.tres" % key.to_lower())))
	info.make_read_only()
