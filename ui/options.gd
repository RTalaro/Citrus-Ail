extends Control

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)

func on_visibility_changed():
	print("visibility changed")
	get_tree().paused = !get_tree().paused
	if get_parent().get_child_count() < 7:
		$ColorRect.visible = false
	else: $ColorRect.visible = true
