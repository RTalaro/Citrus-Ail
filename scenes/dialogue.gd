extends Control

## Choice either taken or timed out
signal choice_end
## Action ready for flashing
signal action_ready
## Ginger ready for turn animation
signal turn
## End of scene
signal scene_end

## Pause after turn animation
const TURN_SPEED: float = 0.0
const TEXT_SPEED: float = 0.4

## Dialogue file
var dialogue: FileAccess
## Delay after reading line
var seconds: float
## Current line
var line: String
## Number of lines processed
var lines: int = 0
var choice_num: int = 0
var choice_labels: Array[Label]
var choice_bubbles: Array[TextureButton]

@onready var bubble: TextureRect = $Bubble
@onready var text_ginger: Label = $Bubble/Text
@onready var timer: Timer = $Timer
@onready var choice_timer: Timer = $ChoiceTimer


func _ready() -> void:
	bubble.set_modulate(Color(1, 1, 1, 0)) ## REMOVE FOR SUBMISSION AND SET OPACITY TO 0
	for i: int in get_child_count():
		var choice: Node = get_child(i)
		if choice is not TextureButton:
			continue
		choice_bubbles.append(choice)

		choice_labels.append(choice.get_child(0))
		choice.set_modulate(Color(1, 1, 1, 0)) ## REMOVE FOR SUBMISSION AND SET OPACITY TO 0
		choice.hide() ## REMOVE FOR SUBMISSION AND SET TO INVISIBLE
		choice.disabled = true
		choice.button_down.connect(on_choice_down.bind(i))
	choice_timer.timeout.connect(on_choice_end)


func run_dialogue(dialogue_path):
	print("run dialogue %s" % dialogue_path)
	dialogue = FileAccess.open(dialogue_path, FileAccess.READ)

	text_ginger.visible_characters = 0
	text_ginger.text = ''
	while not dialogue.eof_reached():
		line = dialogue.get_line()
		lines += 1
		seconds = 0
		print("line %s" % line)

		if line == "":
			continue

		## Ginger's dialogue
		if line.begins_with("G: "):
			seconds = 2
			if line.contains("(choice)"):
				choice_num = 0
				seconds = 0
				line = line.erase(line.length() - 8, line.length() - 1)
			text_ginger.visible_characters = 0
			text_ginger.text = ''
			text_ginger.text = line.erase(0, 2)
			var tween: Tween = create_tween()
			tween.tween_property(bubble, "modulate:a", 1, 1)
			while text_ginger.visible_characters != len(text_ginger.text):
				timer.start(TEXT_SPEED)
				await timer.timeout

				text_ginger.visible_characters += 1

		## Choice section
		elif line.begins_with("A: "):
			## Fade in choices
			for i: int in range(2):
				var choice: TextureButton = choice_bubbles[i + 1]
				var label: Label = choice_labels[i + 1]
				choice.show()
				if i > 0:
					line = dialogue.get_line()
					lines += 1
				label.text = line.erase(0, 2)
			var tween: Tween = create_tween().set_parallel()
			for choice: TextureButton in choice_bubbles:
				tween.tween_property(choice, "modulate:a", 1, 1)
			await tween.finished

			## Give player 5 seconds to respond.
			## When choice_timer ends, on_choice_end is called
			## and choice_end is emitted
			print("start choice timer")
			choice_timer.start(5)
			for choice: TextureButton in choice_bubbles:
				choice.disabled = false
			await choice_end

			print("choice end received")

		elif line.contains("Pause"):
			print("fade out")
			seconds = line.to_int()
			var tween: Tween = create_tween()
			tween.tween_property(bubble, "modulate:a", 0, 1)
		elif line == "(Action)":
			action_ready.emit()
		elif line == "(Turn)":
			turn.emit()
			seconds = TURN_SPEED
			line = dialogue.get_line()
			lines += 1
			## BUG
			timer.start(seconds)
			await timer.timeout

			scene_end.emit(line)
		timer.start(seconds)
		await timer.timeout


func on_choice_down(num: int):
	choice_num = num
	on_choice_end()


func on_choice_end():
	print("choice end")
	for choice: TextureButton in choice_bubbles:
		choice.disabled = true
	choice_timer.stop()

	var tween: Tween = create_tween().set_parallel()
	## Fade out choices
	for choice: TextureButton in choice_bubbles:
		tween.tween_property(choice, "modulate:a", 0, 1)

	## Read Ginger's dialogue
	for i: int in range(choice_num + 2):
		line = dialogue.get_line()
		lines += 1
	print(choice_num)
	print(line)
	seconds = 2
	text_ginger.visible_characters = 0
	text_ginger.text = ''
	text_ginger.text = line.erase(0, 2)
	## Fade in bubble
	tween = create_tween()
	tween.tween_property(bubble, "modulate:a", 1, 1)
	await tween.finished

	for choice: TextureButton in choice_bubbles:
		choice.hide()
	while text_ginger.visible_characters != len(text_ginger.text):
		timer.start(TEXT_SPEED)
		await timer.timeout

		text_ginger.visible_characters += 1
	timer.start(seconds)
	await timer.timeout

	## Realign dialogue
	for i: int in range(3 - choice_num):
		line = dialogue.get_line()
		lines += 1

	choice_end.emit()
