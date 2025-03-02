extends Timer

signal weather_changed(weather: Weather)

# Define the Weather Enum
enum Weather {
	SUN,
	RAIN,
	STORM
}

const WEATHER_MIN_TIME: float = 5.0
const WEATHER_MAX_TIME: float = 10.0

@export var rain_particles: GPUParticles2D
@export var lightning_particles: GPUParticles2D
@export var cloud_sprite: Sprite2D

# Declare a variable for current weather
var current_weather: Weather

# Timer variable
var weather_timer: Timer

# Called when the node enters the scene tree
func _ready():
	# Create and configure a Timer node
	weather_timer = Timer.new()
	add_child(weather_timer)  # Add the timer as a child node
	
	# Connect the timeout signal to the function using the correct callable
	weather_timer.connect("timeout", Callable(self, "_on_weather_timer_timeout"))

	# Start the process by calling a function to change weather
	_change_weather()

# Function to start the weather change process
func _change_weather():
	# Randomize the time range for the weather change (for example, between 2 and 5 seconds)
	var random_time = randi_range(WEATHER_MIN_TIME, WEATHER_MAX_TIME)  # Use randi_range() for integer range

	# Start the timer to wait for the random amount of time
	weather_timer.start(random_time)

# Timer callback function
func _on_weather_timer_timeout():
	# Randomly choose a weather condition from the enum
	set_weather(Weather.values()[randi_range(0, Weather.size() - 1)])


## Sets the current weather.
func set_weather(type: Weather) -> void:
	current_weather = type
	
	# Print the current weather condition for debugging
	match current_weather:
		Weather.SUN:
			rain_particles.emitting = false
			lightning_particles.emitting = false
			cloud_sprite.visible = false
		Weather.RAIN:
			rain_particles.emitting = true
			lightning_particles.emitting = false
			cloud_sprite.visible = true
		Weather.STORM:
			rain_particles.emitting = true
			lightning_particles.emitting = true
			cloud_sprite.visible = true

	# After handling the weather change, restart the weather change process
	_change_weather()
