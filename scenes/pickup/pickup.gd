extends Control

# Optionally, you can preload or assign a texture for the icon
var texture_icon: Texture

func _ready():
	texture_icon = preload("res://assets/tiles/fire.png")  
	$TextureRect.texture = texture_icon

# Handling mouse input for the pickup interaction
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_rect().has_point(event.position):
			on_pickup_clicked()

# Code to execute when the pickup is clicked
func on_pickup_clicked():
	print("Pickup item clicked!")
	# Execute some other logic here (e.g., adding to inventory, etc.)
	# After executing, the pickup is freed
	queue_free()  # This removes the pickup object from the scene
