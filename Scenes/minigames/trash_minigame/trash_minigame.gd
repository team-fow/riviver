extends Minigame

const CLOSE_TIME: float = 4.0

@export var level: Level
@export var trash_objects: Array[TrashObject]

@onready var close_timer: Timer = $CloseTimer
@onready var animator: AnimationPlayer = $Animator

var trash_correct: int = 0
var total_trash: int


func _ready() -> void:
	total_trash = trash_objects.size()
	for trash: TrashObject in trash_objects:
		trash.grabbed.connect(_on_trash_grabbed)
		trash.eaten.connect(_on_trash_eaten.bind(trash))
	for child: Node in get_children():
		if child is TrashBin:
			child.trash_added.connect(func(correct: bool): if correct: trash_correct+=1)
	close_timer.timeout.connect(level.close_minigame.bind(self))


func _on_trash_grabbed() -> void:
	level.open_minigame(self)
	close_timer.stop()


func _on_trash_eaten(trash: TrashObject) -> void:
	trash_objects.erase(trash)
	
	if trash_objects.is_empty():
		end()
	else:
		close_timer.start(CLOSE_TIME)


func end() -> void:
	score = float(trash_correct)/float(total_trash)
	
	var tween: Tween = create_tween().set_parallel().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	for child: Node in get_children():
		if child is TrashBin:
			tween.tween_property(child, "position:x", child.position.x + 800.0, 0.5)
			tween.tween_property(child, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	$Animation/Bottom/Center/Expression.frame = floori(score)

	animator.play("drive_truck")
	await animator.animation_finished
	
	ended.emit(self, score)
