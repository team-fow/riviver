extends Minigame

const CLOSE_TIME: float = 4.0

@export var level: Level
@export var trash_objects: Array[TrashObject]

@onready var close_timer: Timer = $CloseTimer


func _ready() -> void:
	for trash: TrashObject in trash_objects:
		trash.grabbed.connect(_on_trash_grabbed)
		trash.dropped.connect(_on_trash_dropped.bind(trash))
	close_timer.timeout.connect(level.close_minigame.bind(self))


func _on_trash_grabbed() -> void:
	level.open_minigame(self)
	close_timer.stop()


func _on_trash_dropped(trash: TrashObject) -> void:
	close_timer.start(CLOSE_TIME)
	trash_objects.erase(trash)
	
	if trash_objects.is_empty():
		score = 1.0
		ended.emit(self, score)
