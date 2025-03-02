class_name WeatherCardInfo
extends CardInfo

const WeatherScript = preload("res://scenes/game/weather_timer.gd")

@export var weather: WeatherScript.Weather


func play(target: Tile) -> void:
	Game.clock.weather.set_weather(weather)


func can_be_played(target: Tile) -> bool:
	return true
