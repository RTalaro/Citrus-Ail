extends TextureButton


func _ready() -> void:
	## Set click mask
	if texture_normal:
		var image: Image = texture_normal.get_image()
		var bitmap: BitMap = BitMap.new()
		bitmap.create_from_image_alpha(image)
		texture_click_mask = bitmap
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func on_mouse_entered():
	if visible:
		set_modulate(Color(1, 1, 1, 0.5))


func on_mouse_exited():
	if visible:
		set_modulate(Color(1, 1, 1, 1))
