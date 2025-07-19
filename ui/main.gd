extends Control

@onready var play = $MarginContainer/VBoxContainer/Play
@onready var options = $MarginContainer/VBoxContainer/Options
@onready var quit = $MarginContainer/VBoxContainer/Quit


func _ready():
	
	# connect all buttons
	play.button_down.connect(on_start_button_pressed)
	options.button_down.connect(on_options_button_pressed)
	quit.button_down.connect(on_quit_button_pressed)


func on_start_button_pressed() -> void:
	print('start game')
	print('load scene 1')
	get_tree().change_scene_to_file("res://scenes/scene1.tscn")

func on_options_button_pressed() -> void:
	print('start game')
	print('load scene 1')
	get_tree().change_scene_to_file("res://scenes/scene1.tscn")

func on_quit_button_pressed() -> void:
	print('quit game')
	get_tree().quit()
