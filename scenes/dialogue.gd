extends Control

@onready var bubble = $Bubble
@onready var text_ginger = $Bubble/Text
@onready var timer = $Timer
@onready var Ginger = $"../Ginger"
@onready var choice1 = $Choice1
@onready var text_choice1 = $Choice1/Text
@onready var choice2 = $Choice2
@onready var text_choice2 = $Choice2/Text
@onready var choice3 = $Choice3
@onready var text_choice3 = $Choice3/Text
@onready var choice_timer = $ChoiceTimer

# dialogue file
var dialogue
# delay after reading line
var seconds : float
# current line
var line : String
# number of lines processed
var lines : int = 0
# selected choice
var choice_num : int = 0
# duration of pause after turn animation
@export var turn_duration : float

# choice either taken or timed out
signal choice_end
# action ready for flashing
signal action_ready
# ginger ready for turn animation
signal turn
# end of scene
signal scene_end


func _ready() -> void:
	bubble.set_modulate(Color(1,1,1,0)) # REMOVE FOR SUBMISSION AND SET OPACITY TO 0
	choice1.set_modulate(Color(1,1,1,0)) # REMOVE FOR SUBMISSION
	choice2.set_modulate(Color(1,1,1,0)) # REMOVE FOR SUBMISSION
	choice3.set_modulate(Color(1,1,1,0)) # REMOVE FOR SUBMISSION
	choice1.visible = false # REMOVE FOR SUBMISSION AND SET TO INVISIBLE
	choice2.visible = false # REMOVE FOR SUBMISSION AND SET TO INVISIBLE
	choice3.visible = false # REMOVE FOR SUBMISSION AND SET TO INVISIBLE
	
	choice1.disabled = true
	choice2.disabled = true
	choice3.disabled = true
	choice1.button_down.connect(on_choice1_down)
	choice2.button_down.connect(on_choice2_down)
	choice3.button_down.connect(on_choice3_down)
	choice_timer.timeout.connect(on_choice_end)

func run_dialogue(dialogue_path):
	print("run dialogue")
	dialogue = FileAccess.open(dialogue_path, FileAccess.READ)
	
	text_ginger.visible_characters = 0
	text_ginger.text = ''
	while not dialogue.eof_reached():
		line = dialogue.get_line()
		lines += 1
		seconds = 0
		print(line)
		
		if line == "":
			continue
		
		# ginger's dialogue
		if line.begins_with("G: "):
			seconds = 2
			if line.contains("(choice)"):
				choice_num = 0
				seconds = 0
				line = line.erase(line.length()-8, line.length()-1)
			text_ginger.visible_characters = 0
			text_ginger.text = ''
			text_ginger.text = line.erase(0,2)
			var tween = create_tween()
			tween.tween_property(bubble, "modulate:a", 1, 1)
			while text_ginger.visible_characters != len(text_ginger.text):
				timer.start(.04)
				await timer.timeout
				text_ginger.visible_characters += 1
		
		# choice section
		elif line.begins_with("A: "):
			# fade in choices
			choice1.visible = true
			text_choice1.text = line.erase(0,2)
			choice2.visible = true
			line = dialogue.get_line()
			lines += 1
			text_choice2.text = line.erase(0,2)
			choice3.visible = true
			line = dialogue.get_line()
			lines += 1
			text_choice3.text = line.erase(0,2)
			var tween = create_tween().set_parallel()
			tween.tween_property(choice1, "modulate:a", 1, 1)
			tween.tween_property(choice2, "modulate:a", 1, 1)
			tween.tween_property(choice3, "modulate:a", 1, 1)
			await tween.finished
			# give player 5 seconds to respond
			print("start choice timer")
			choice_timer.start(5)
			choice1.disabled = false
			choice2.disabled = false
			choice3.disabled = false
			await choice_end
			print("choice end received")
		
		elif line.contains("Pause"):
			print("fade out")
			seconds = line.to_int()
			var tween = create_tween()
			tween.tween_property(bubble, "modulate:a", 0, 1)
		elif line == "(Action)":
			action_ready.emit()
		elif line == "(Turn)":
			turn.emit()
			seconds = turn_duration
			line = dialogue.get_line()
			lines += 1
			#debug
			timer.start(seconds)
			await timer.timeout
			scene_end.emit(line)
		timer.start(seconds)
		await timer.timeout




func on_choice1_down():
	choice_num = 1
	on_choice_end()
func on_choice2_down():
	choice_num = 2
	on_choice_end()
func on_choice3_down():
	choice_num = 3
	on_choice_end()

func on_choice_end():
	print("choice end")
	choice1.disabled = true
	choice2.disabled = true
	choice3.disabled = true
	choice_timer.stop()
	
	# fade out choices
	var tween = create_tween().set_parallel()
	tween.tween_property(choice1, "modulate:a", 0, 1)
	tween.tween_property(choice2, "modulate:a", 0, 1)
	tween.tween_property(choice3, "modulate:a", 0, 1)
	
	# read ginger's dialogue
	for i in range(choice_num + 2):
		line = dialogue.get_line()
		lines += 1
	print(choice_num)
	print(line)
	seconds = 2
	text_ginger.visible_characters = 0
	text_ginger.text = ''
	text_ginger.text = line.erase(0,2)
	# fade in bubble
	tween = create_tween()
	tween.tween_property(bubble, "modulate:a", 1, 1)
	await tween.finished
	choice1.visible = false
	choice2.visible = false
	choice3.visible = false
	while text_ginger.visible_characters != len(text_ginger.text):
		timer.start(.04)
		await timer.timeout
		text_ginger.visible_characters += 1
	timer.start(seconds)
	await timer.timeout
	# realign dialogue
	for i in range(3 - choice_num):
		line = dialogue.get_line()
		lines += 1
	
	choice_end.emit()
