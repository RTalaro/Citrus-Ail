extends TextureButton

@export var choice: int

## Amount to float around by
var variance: int = 10
var duration: int = 2


func _ready() -> void:
	## Set click mask
	if texture_normal:
		var image: Image = texture_normal.get_image()
		var bitmap: BitMap = BitMap.new()
		bitmap.create_from_image_alpha(image)
		texture_click_mask = bitmap

	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	tween_me()


func tween_me() -> void:
	var tween: Tween = create_tween().set_loops(INF)
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", Vector2(position.x + variance, position.y + variance), duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(position.x - variance, position.y - variance), duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func on_mouse_entered():
	if visible:
		set_modulate(Color(1, 1, 1, 0.5))


func on_mouse_exited():
	if visible:
		set_modulate(Color(1, 1, 1, 1))
