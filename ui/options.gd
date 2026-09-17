extends Control

@onready var exit_button: TextureButton = $MenuBG/ExitButton
@onready var dim: ColorRect = $Dim
@onready var menu_bg: TextureRect = $MenuBG


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visibility_changed.connect(on_visibility_changed)
	exit_button.button_down.connect(on_exit_button_down)


func on_visibility_changed():
	get_tree().paused = !get_tree().paused
	dim.visible = !SceneManager.in_menu
	menu_bg.visible = SceneManager.in_menu


func on_exit_button_down():
	visible = !visible
