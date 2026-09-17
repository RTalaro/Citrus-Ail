extends TextureRect

## Amount to float around by
@export var variance: int
@export var duration: float


func _ready() -> void:
	tween_me()


func tween_me() -> void:
	var tween: Tween = create_tween().set_loops(INF)
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", Vector2(position.x + variance, position.y + variance), duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(position.x - variance, position.y - variance), duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
