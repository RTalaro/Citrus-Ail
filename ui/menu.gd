extends Control

#preload all scenes
var scene1 = preload("res://scenes/scene1.tscn").instantiate()
#var scene2 = preload("res://scenes/scene2.tscn").instantiate()
#var scene3 = preload("res://scenes/scene3.tscn").instantiate()
#var scene4 = preload("res://scenes/scene4.tscn").instantiate()
#var scene5 = preload("res://scenes/scene5.tscn").instantiate()
#var scene6 = preload("res://scenes/scene6.tscn").instantiate()
#var scene7 = preload("res://scenes/scene7.tscn").instantiate()

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
	add_child(scene1)

func on_options_button_pressed() -> void:
	print('open options')

func on_quit_button_pressed() -> void:
	print('quit game')
	get_tree().quit()
