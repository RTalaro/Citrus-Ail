extends TextureRect

var velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	tween_me()
	

#func _process(delta: float) -> void:
	#position -= position.lerp(position - velocity, -50 * delta)

func tween_me() -> void:
	var tween = create_tween().set_loops(INF)
	tween.tween_property(self, "position", Vector2(position.x+10, position.y+10), 3)\
	.as_relative().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", Vector2(position.x-10, position.y-10), 3)\
	.as_relative().set_trans(Tween.TRANS_CUBIC)
