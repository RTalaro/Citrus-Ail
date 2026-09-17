extends Control

signal credits_done

var timer: Timer = Timer.new()

@onready var role: Label = $MarginContainer/VBoxContainer/Role
@onready var member: Label = $MarginContainer/VBoxContainer/Name
@onready var engine: Label = $Engine


func _ready() -> void:
	role.set_modulate(Color(1, 1, 1, 0))
	member.set_modulate(Color(1, 1, 1, 0))
	engine.set_modulate(Color(1, 1, 1, 0))
	add_child(timer)

	var tween: Tween = create_tween()
	tween.tween_property(engine, "modulate:a", 1, 2)
	await tween.finished

	await set_credits("Design", "Reece Talaro")
	await set_credits("Programming", "Reece Talaro")
	await set_credits("Art", "Reece Talaro")
	await set_credits("Writing", "Reece Talaro")
	await set_credits("Sound", "Beadie")


## Fade in role and names over 1s, wait 5s, then fade out over 1s.
func set_credits(role_name: String, member_name: String):
	timer.start(1)
	await timer.timeout

	role.text = role_name
	member.text = member_name

	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(role, "modulate:a", 1, 1)
	tween.tween_property(member, "modulate:a", 1, 1)

	timer.start(5)
	await timer.timeout

	tween = create_tween().set_parallel()
	tween.tween_property(role, "modulate:a", 0, 1)
	tween.tween_property(member, "modulate:a", 0, 1)
	await tween.finished

	credits_done.emit()
