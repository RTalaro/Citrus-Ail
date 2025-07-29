extends Control

@onready var bubble = $Bubble
@onready var text_ginger = $Bubble/Text
@onready var timer = $Timer
@onready var Ginger = $"../Ginger"


var seconds : int
var line : String
signal end_line
signal action_ready
signal turn
signal scene_end


func _ready() -> void:
	bubble.set_modulate(Color(1,1,1,0)) # REMOVE FOR SUBMISSION AND SET OPACITY TO 0

func run_dialogue(dialogue_path):
	print("run dialogue")
	var dialogue = FileAccess.open(dialogue_path, FileAccess.READ)
	
	while not dialogue.eof_reached():
		text_ginger.visible_characters = 0
		text_ginger.text = ''
		line = dialogue.get_line()
		seconds = line.to_int()
		print(line)
		if line.contains("Pause"):
			print("fade out")
			var tween = create_tween()
			tween.tween_property(bubble, "modulate:a", 0, 1)
		elif line == "(Action)":
			action_ready.emit()
		elif line == "(Turn)":
			turn.emit()
		elif line.begins_with("G:"):
			text_ginger.text = line.erase(0,2)
			var tween = create_tween()
			tween.tween_property(bubble, "modulate:a", 1, 1)
			timer.start(.5)
			await timer.timeout
			while text_ginger.visible_characters != len(text_ginger.text):
				timer.start(.04)
				await timer.timeout
				text_ginger.visible_characters += 1
			seconds = 2
		#elif line.begins_with("1:"):
		timer.start(seconds)
		await timer.timeout
	scene_end.emit()
