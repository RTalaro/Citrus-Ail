extends Control

@onready var exit = $MenuBG/TextureButton

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)
	exit.button_down.connect(on_exit_button_down)

func on_visibility_changed():
	get_tree().paused = !get_tree().paused
	if get_parent().get_child_count() < 7:
		$Dim.visible = false
		$MenuBG.visible = true
	else:
		$Dim.visible = true
		$MenuBG.visible = false

func on_exit_button_down():
	visible = !visible
