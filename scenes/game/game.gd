class_name Game
extends Node2D

static var grid: Grid ## Grid of tiles.
static var tick_timer: Timer ## Coordinates and times ticks.


func _ready() -> void:
	# setting shorthand variables
	grid = $Grid
	tick_timer = $TickTimer
