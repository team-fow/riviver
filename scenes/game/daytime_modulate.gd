class_name Clock
extends CanvasModulate

# Daytime Management
const DAY_LENGTH: float = 120.0  # Duration of a full day, in seconds.
var time: float = DAY_LENGTH / 2  # Current time, in seconds.
var gradient: Gradient = load("res://assets/daytime_gradient.tres")  # Color applied based on the time of day.
var day_counter: int = 0  # Counter for the number of days that have passed in the current year
var year_counter: int = 0  # Counter for the number of years that have passed
const TIME_SCALE: float = 1.0  # Speed of time (1.0 = normal speed)

# Season Management
enum Season { SPRING, SUMMER, FALL, WINTER }  # Enum for seasons (0 -> SPRING, 1 -> SUMMER, 2 -> FALL, 3 -> WINTER.)
var season: int = Season.SPRING  # Current season (initially Spring, using the enum value directly)
const SEASON_LENGTH: int = 6  # Number of days in each season 

# Control how much longer the night should last (night_scale is greater than 1 to make night longer High Number than 1 = Longer Nights , Lower Number than 1 = Faster Night)
const NIGHT_SCALE: float = 1.5  # Scale factor for the night (1.5 means night will last 1.5x longer than day)

func _process(delta):
	# Time progression, but slower at night
	var adjusted_delta = delta * TIME_SCALE
	if time > DAY_LENGTH / 2:  # If we're in the night phase (after the midpoint)
		adjusted_delta *= NIGHT_SCALE  # Make time pass slower during the night

	# Update time with adjusted delta
	time = fmod(time + adjusted_delta, DAY_LENGTH)
	
	# Check if a day has passed and increment the day counter
	if time < adjusted_delta:  # This checks if the time has reset (indicating a new day)
		day_counter += 1
	
	# Increment the season every 6 days
	season = int(day_counter / SEASON_LENGTH) % 4  # Map to the correct season enum value

	# Check if all four seasons have passed (24 days for a full year)
	if day_counter >= SEASON_LENGTH * 4:  # 4 seasons * 6 days per season = 24 days per year 
		year_counter += 1  # Increment the year counter
		day_counter = 0  # Reset day counter
		season = Season.SPRING  # Reset season to SPRING at the start of the new year

	# Set the color based on time of day
	color = gradient.sample(sin(time / DAY_LENGTH * PI) * 0.5 + 0.5)

	# Debug: Print the day counter, current season, and year counter (optional)
	print("Day: ", day_counter, "Season: ", Season.values()[season], "Year: ", year_counter)
