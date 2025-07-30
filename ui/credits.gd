extends Control


@onready var title = $MarginContainer/VBoxContainer/Title
@onready var role = $MarginContainer/VBoxContainer/Role
@onready var member = $MarginContainer2/Name

@onready var godot_label = $MarginContainer3/VBoxContainer/GodotLabel

var timer = Timer.new()

signal credits_done


func _ready() -> void:
	title.set_modulate(Color(1,1,1,0))
	role.set_modulate(Color(1,1,1,0))
	member.set_modulate(Color(1,1,1,0))
	godot_label.set_modulate(Color(1,1,1,0))
	add_child(timer)
	
	# fade in credits line
	var tween = create_tween()
	tween.tween_property(title, "modulate:a", 1, 2)
	await tween.finished
	
	set_credits("Design", "Reece Talaro")
	await credits_done
	set_credits("Programming", "Reece Talaro")
	await credits_done
	set_credits("Art", "Reece Talaro")
	await credits_done
	set_credits("Writing", "Reece Talaro")
	await credits_done
	set_credits("Sound", "Beadie")
	await credits_done
	tween = create_tween()
	tween.tween_property(godot_label, "modulate:a", 1, 1)
	

func set_credits(role_name: String, member_name: String):
	timer.start(1)
	await timer.timeout
	#print("timer 1 done")
	
	role.text = role_name
	member.text = member_name
	
	var tween = create_tween().set_parallel()
	tween.tween_property(role, "modulate:a", 1, 1)
	tween.tween_property(member, "modulate:a", 1, 1)
	
	timer.start(5)
	await timer.timeout
	#print("timer 5 done")
	
	if(role_name != "Sound"):
		tween = create_tween().set_parallel()
		tween.tween_property(role, "modulate:a", 0, 1)
		tween.tween_property(member, "modulate:a", 0, 1)
		await tween.finished
	credits_done.emit()
