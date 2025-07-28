extends HSlider


@export_enum("Master", "Music", "SFX") var bus: String
var audio : int

func _ready() -> void:
	value_changed.connect(on_value_changed)
	audio = AudioServer.get_bus_index(bus)
	value = db_to_linear(audio)

func on_value_changed(value):
	AudioServer.set_bus_volume_db(audio, linear_to_db(value))
