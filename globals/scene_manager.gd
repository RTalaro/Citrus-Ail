extends Node

var root: Node
var music: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx: AudioStreamPlayer = AudioStreamPlayer.new()

@onready var in_menu: bool = true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	music.bus = "Music"
	music.stream = load("res://assets/BGM.mp3")
	music.autoplay = true
	sfx.bus = "SFX"
	add_child(music)
