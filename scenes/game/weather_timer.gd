extends Timer

# Define the Weather Enum
enum Weather {
	SUN,
	RAIN,
	STORM
}

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
	var random_time = randi_range(2, 5)  # Use randi_range() for integer range

	# Start the timer to wait for the random amount of time
	weather_timer.start(random_time)

# Timer callback function
func _on_weather_timer_timeout():
	# Randomly choose a weather condition from the enum
	current_weather = Weather.values()[randi_range(0, Weather.size() - 1)]  # Correctly access enum values
	
	# Print the current weather condition for debugging
	match current_weather:
		Weather.SUN:
			print("The weather is sunny!")
		Weather.RAIN:
			print("It's raining!")
		Weather.STORM:
			print("There's a storm!")

	# After handling the weather change, restart the weather change process
	_change_weather()
