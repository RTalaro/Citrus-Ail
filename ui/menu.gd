extends Control

# preload scene 1
var next_scene = preload("res://scenes/scene1.tscn").instantiate()

@onready var play = $MarginContainer/VBoxContainer/Play
@onready var options = $MarginContainer/VBoxContainer/Options
@onready var quit = $MarginContainer/VBoxContainer/Quit

# $Menu/Scene/Dialogue
var dialogue : Control
var bubble : TextureRect
var choice1 : TextureButton
var choice2 : TextureButton
var choice3 : TextureButton
var action : TextureButton
var Ginger : Control
var timer : Timer

# tracks current scene
var scene_num : int = 0
var next_scene_path : String
var dialogue_path : String
var old_scene : Node

func _ready():
	# connect all signals
	#play.button_down.connect(on_scene1_end)
	play.button_down.connect(on_scene_start.bind(''))
	# ignore game pause
	process_mode = 3
	options.process_mode = 3
	$MusicVol.process_mode = 3
	$SFXVol.process_mode = 3
	options.button_down.connect(on_options_button_pressed)
	options.visibility_changed.connect(on_game_pause)
	quit.button_down.connect(on_quit_button_pressed)


func on_options_button_pressed() -> void:
	$Options.visible = true

func on_game_pause() -> void:
	get_tree().paused = !get_tree().paused

func on_quit_button_pressed() -> void:
	get_tree().quit()


func on_scene_start(line):
	if scene_num:
		# play scene end animation
		$Scene/SceneEnd.visible = true
		$Scene/SceneEnd/AnimatedSprite2D.play("end")
		$Scene/SceneEnd/AnimatedSprite2D2.play("end")
		await $Scene/SceneEnd/AnimatedSprite2D2.animation_finished
		
		#print her final line
		$Scene/SceneEnd/FinalLine/Text.text = line
		$Scene/SceneEnd/FinalLine.visible = true
		timer.start(1)
		await timer.timeout
	
	# update scene info and load next scene
	if scene_num: old_scene = $Scene
	add_child(next_scene)
	if scene_num:
		remove_child(old_scene)
		old_scene.queue_free()
	next_scene.name = "Scene"
	print(next_scene.name)
	
	scene_num += 1
	dialogue_path = "res://dialogue/scene%d.txt" % (scene_num)
	next_scene_path = "res://scenes/scene%d.tscn" % (scene_num + 1)
	next_scene = load(next_scene_path).instantiate()
	#if scene_num: old_scene.queue_free()
	#next_scene.name = "Scene"
	
	# connect all scene nodes/signals
	Ginger = $Scene/Ginger
	action = $Scene/Action
	dialogue = $Scene/Dialogue
	bubble = $Scene/Dialogue/Bubble
	choice1 = $Scene/Dialogue/Choice1
	choice2 = $Scene/Dialogue/Choice2
	choice3 = $Scene/Dialogue/Choice3
	timer = $Scene/Dialogue/Timer
	action.mouse_entered.connect(on_action_taken)
	dialogue.action_ready.connect(on_action_ready)
	choice1.button_down.connect(on_choice_selected)
	choice2.button_down.connect(on_choice_selected)
	choice3.button_down.connect(on_choice_selected)
	dialogue.scene_end.connect(on_scene_start)
	dialogue.turn.connect(on_turn)
	
	# start scene
	if scene_num == 1:
		$Scene/Ginger/Body.play("walk")
		$Scene/Ginger/Face.play("hair")
	
	# run dialogue
	dialogue.run_dialogue(dialogue_path)

func on_action_taken():
	print("action taken")
	var tween = create_tween()
	tween.tween_property(action, "modulate:a", 0, 1.5)
	await tween.finished
	action.visible = false
	$Scene/Ginger/Body.play("walkhand")
	$Scene/Ginger/Face.play("hair")
	

func on_action_ready():
	print("show action")
	action.set_modulate(Color(1,1,1,0)) # REMOVE FOR SUBMISSION AND MAKE ACTION OPACITY 0
	action.visible = true
	var tween = create_tween().set_loops(INF)
	tween.tween_property(action, "modulate:a", 0.75, 1.5)
	tween.tween_property(action, "modulate:a", 0.25, 1.5)

func on_choice_selected():
	print("choice selected")
	choice1.disabled = true
	choice2.disabled = true
	choice3.disabled = true
	var tween = create_tween().set_parallel()
	tween.tween_property(choice1, "modulate:a", 0, 1)
	tween.tween_property(choice2, "modulate:a", 0, 1)
	tween.tween_property(choice3, "modulate:a", 0, 1)
	await tween.finished

	choice1.visible = false
	choice2.visible = false
	choice3.visible = false

func on_turn():
	var tween = create_tween()
	tween.tween_property(action, "modulate:a", 0, 1)
	await tween.finished
	action.visible = false
	$Scene/Ginger/Body.stop()
	$Scene/Ginger/Face.stop()
	$Scene/Ginger/Face.play("turn")

func _input(event) -> void:
	if event.is_action_pressed("options"):
		$Options.visible = !$Options.visible


# for testing
#func on_scene1_end():
	#add_child(next_scene)
	#next_scene.name = "Scene"
	#next_scene.process_mode = 1
	#$Scene/Ginger/Body.play("walk")
	# realign animation
	#timer = Timer.new()
	#add_child(timer)
	#timer.start(.4)
	#await timer.timeout
	#timer.queue_free()
	#$Scene/Ginger/Face.play("hair")
	#Ginger = $Scene/Ginger
	#action = $Scene/Action
	#dialogue = $Scene/Dialogue
	#bubble = $Scene/Dialogue/Bubble
	#choice1 = $Scene/Dialogue/Choice1
	#choice2 = $Scene/Dialogue/Choice2
	#choice3 = $Scene/Dialogue/Choice3
	#timer = $Scene/Dialogue/Timer
	#action.mouse_entered.connect(on_action_taken)
	#dialogue.action_ready.connect(on_action_ready)
	#choice1.button_down.connect(on_choice_selected)
	#choice2.button_down.connect(on_choice_selected)
	#choice3.button_down.connect(on_choice_selected)
	#dialogue.turn.connect(on_turn)
	#dialogue.scene_end.connect(on_scene_start)
	#dialogue.run_dialogue("res://dialogue/scene1.txt")
