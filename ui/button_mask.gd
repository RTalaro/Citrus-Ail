extends TextureButton

func _ready() -> void:
	# set click mask
	if texture_normal:
		var image = texture_normal.get_image()
		var bitmap = BitMap.new()
		bitmap.create_from_image_alpha(image)
		texture_click_mask = bitmap
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func on_mouse_entered():
	if visible: self.set_modulate(Color(1,1,1, 0.5))

func on_mouse_exited():
	if visible: self.set_modulate(Color(1,1,1, 1))
