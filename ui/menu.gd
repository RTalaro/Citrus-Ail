extends Control

# preload scene 1
var next_scene = preload("res://scenes/scene1.tscn").instantiate()

@onready var play = $MarginContainer/VBoxContainer/Play
@onready var options = $MarginContainer/VBoxContainer/Options
@onready var quit = $MarginContainer/VBoxContainer/Quit

# $Menu/Scene/Dialogue
var dialogue : Control
var action : TextureRect
var Ginger : Control
var timer : Timer

# tracks current scene
var scene_num : int = 0
var next_scene_path : String
var dialogue_path : String
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

# for testing
func on_scene1_end():
	add_child(next_scene)
	next_scene.name = "Scene"
	$Scene/Ginger/Body.play("walk")
	timer = Timer.new()
	add_child(timer)
	timer.start(.4)
	await timer.timeout
	timer.queue_free()
	$Scene/Ginger/Face.play("hair")
	action = $Scene/Action
	dialogue = $Scene/Dialogue
	dialogue.action_ready.connect(on_action_ready)
	dialogue.scene_end.connect(start_scene)
	dialogue.run_dialogue("res://dialogue/scene1.txt")
	


func start_scene():
	# play scene end animation
	if scene_num:
		$Scene/SceneEnd.visible = true
		$Scene/SceneEnd/AnimatedSprite2D.play("end")
		await $Scene/SceneEnd/AnimatedSprite2D.animation_finished
	
	# update scene info and load next scene
	if scene_num: old_scene = $Scene
	add_child(next_scene)
	scene_num += 1
	dialogue_path = "res://dialogue/scene%d.txt" % (scene_num)
	next_scene_path = "res://scenes/scene%d.tscn" % (scene_num+1)
	next_scene = load(next_scene_path).instantiate()
	if scene_num: old_scene.queue_free()
	else:
		$Scene/Ginger/Body.play("walk")
		# to align both animations
		timer = Timer.new()
		add_child(timer)
		timer.start(.4)
		await timer.timeout
		timer.queue_free()
		$Scene/Ginger/Face.play("hair")
	next_scene.name = "Scene"
	
	# start next scene
	Ginger = $Scene/Ginger
	action = $Scene/Action
	dialogue = $Scene/Dialogue
	timer = $Scene/Dialogue/Timer
	dialogue.action_ready.connect(on_action_ready)
	dialogue.scene_end.connect(start_scene)
	dialogue.run_dialogue(dialogue_path)

func on_action_ready():
	print("show action")
	action.set_modulate(Color(1,1,1,0)) # REMOVE FOR SUBMISSION AND MAKE ACTION OPACITY 0
	action.visible = true
	var tween = create_tween()
	tween.tween_property(action, "modulate:a", 1, 2)
	tween.set_loops(INF)
	tween.tween_property(action, "modulate:a", 0.5, 2)
	tween.tween_property(action, "modulate:a", 0.75, 2)
	action.visible = true
