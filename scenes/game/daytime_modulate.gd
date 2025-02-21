class_name Clock
extends CanvasModulate
## Manages time & weather.

const DAY_LENGTH: float = 120.0 ## Duration of a day, in seconds.

var time: float = DAY_LENGTH / 2 ## Current time, in seconds.
var gradient: Gradient = load("res://assets/daytime_gradient.tres") ## Color applied based on the time of day.


func _process(delta: float) -> void:
	time = fmod(time + delta, DAY_LENGTH)
	color = gradient.sample(sin(time / DAY_LENGTH * PI) * 0.5 + 0.5)
