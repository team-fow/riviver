class_name DenTileBehavior
extends TileBehavior

var task_data: Array[TaskInfo]
var task_list: Array[TaskInfo]

const RADIUS: float = 4.0
const HIGHLIGHT_COLOR := Color("#bfff80")


func get_radius() -> Array[Tile]:
	return Game.grid.get_tiles_in_radius(tile, func(t: Tile): return true, RADIUS**2)


func start() -> void:
	super()
	task_list = []
	for task in task_data:
		var t = task.clone(self.tile)
		task_list.append(t)
		

func stop() -> void:
	super()
	for task in task_list:
		task.free()
	task_list = []
	
	
func input(event: InputType) -> void:
	super(event)
	match event:
		InputType.CLICK:
			for task: TaskInfo in task_list:
				print(task.task_name + ": " + task.task_description)
				print("Completed: " + str(task.check_completed()))
				if task.completed:
					if task.reward_collected:
						print("You have already collected the reward for this task!")
					else:
						print("Collecting reward!")
						task.give_reward()
		InputType.MOUSE_ENTER:
			for tile: Tile in get_radius():
				Game.grid.add_highlight(tile.coords, HIGHLIGHT_COLOR)
		InputType.MOUSE_EXIT:
			for tile: Tile in get_radius():
				Game.grid.remove_highlight(tile.coords)
				
