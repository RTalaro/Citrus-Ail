extends Control

# preload scene 1
var next_scene = preload("res://scenes/scene1.tscn").instantiate()

@onready var play = $MarginContainer/VBoxContainer/Play
@onready var options = $MarginContainer/VBoxContainer/Options
@onready var quit = $MarginContainer/VBoxContainer/Quit

# $Menu/Scene/Dialogue
var dialogue : Control
var Ginger : Control

# tracks current scene
var scene_num : int = 0
var next_scene_path : String = "res://scenes/scene%d.tscn" % scene_num
var old_scene : Node

func _ready():
	# connect all signals
	play.button_down.connect(on_scene1_end)
	#play.button_down.connect(on_scene_end)
	options.button_down.connect(on_options_button_pressed)
	quit.button_down.connect(on_quit_button_pressed)


func on_options_button_pressed() -> void:
	print('open options')

func on_quit_button_pressed() -> void:
	print('quit game')
	get_tree().quit()

func on_scene1_end():
	add_child(next_scene)
	next_scene.name = "Scene"
	dialogue = $Scene/Dialogue
	dialogue.end_scene.connect(on_scene_end)
	dialogue.run_dialogue()
	


func on_scene_end():
	# play scene end animation
	if scene_num:
		$Scene/SceneEnd.visible = true
		$Scene/SceneEnd/AnimatedSprite2D.play("end")
		await $Scene/SceneEnd/AnimatedSprite2D.animation_finished
	
	# update scene info and load next scene
	if scene_num: old_scene = $Scene
	add_child(next_scene)
	scene_num += 1
	next_scene_path = "res://scenes/scene%d.tscn" % (scene_num+1)
	next_scene = load(next_scene_path).instantiate()
	if scene_num: old_scene.queue_free()
	next_scene.name = "Scene"
	
	Ginger = $Scene/Ginger
	dialogue = $Scene/Dialogue
	dialogue.end_scene.connect(on_scene_end)
	
	
