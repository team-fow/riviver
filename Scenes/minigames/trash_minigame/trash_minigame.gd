extends Minigame

const CLOSE_TIME: float = 4.0

@export var level: Level
@export var trash_objects: Array[TrashObject]

@onready var close_timer: Timer = $CloseTimer
@onready var animator: AnimationPlayer = $Animator


func _ready() -> void:
	for trash: TrashObject in trash_objects:
		trash.grabbed.connect(_on_trash_grabbed)
		trash.dropped.connect(_on_trash_dropped.bind(trash))
	close_timer.timeout.connect(level.close_minigame.bind(self))


func _on_trash_grabbed() -> void:
	level.open_minigame(self)
	close_timer.stop()


func _on_trash_dropped(trash: TrashObject) -> void:
	trash_objects.erase(trash)
	
	if trash_objects.is_empty():
		end()
	else:
		close_timer.start(CLOSE_TIME)


func end() -> void:
	score = 1.0
	
	var tween: Tween = create_tween()
	for child: Node in get_children():
		if child is TrashBin:
			tween.tween_property(child, "position:x", child.position.x + 400.0, 0.2)
			tween.tween_property(child, "modulate:a", 0.0, 0.2)
	await tween.finished
	
	animator.play("drive_truck")
	await animator.animation_finished
	
	ended.emit(self, score)
