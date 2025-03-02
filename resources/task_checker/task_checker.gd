class_name TaskChecker
extends GDScript
## Handles checking whether a task is completed


## Determines whether the task is completed. Is overwritten in extensions.
func check_completed(task: TaskInfo) -> bool:
	return false
