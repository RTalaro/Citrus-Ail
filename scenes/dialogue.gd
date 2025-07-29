extends Control

@onready var bubble = $Bubble
@onready var text = $Bubble/Text
@onready var timer = $Timer

var seconds : int
var line : String
signal end_scene


func run_dialogue():
	print("run dialogue")
	var dialogue = FileAccess.open("res://dialogue/scene1.txt", FileAccess.READ)
	
	while not dialogue.eof_reached():
		line = dialogue.get_line()
		seconds = line.to_int()
		print(line)
		if line.begins_with("G:"):
			text.text = line.erase(0,2)
			bubble.visible = true
			var opacity = 0.0
			while opacity < 1:
				bubble.set_modulate(Color(1,1,1,opacity))
				opacity += .1
				timer.start(.1)
				await timer.timeout
		timer.start(seconds)
		await timer.timeout
