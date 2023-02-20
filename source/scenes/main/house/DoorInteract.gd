extends StaticBody3D

@export var leave_door : bool = false

var is_open : bool = false
var interact_text : String = "to open."

# This is here instead of audio manager so that it stops and starts appropriately.
@onready var door_sound : AudioStreamPlayer = $door_creak

func interact() -> void:
	if leave_door:
		check_to_leave()
		return
	toggle_open()


func toggle_open() -> void:
	var target_rotation = 0.0 if is_open else (PI/2)
	
	# Hopefully constant velocity regardless of at what time the door is interacted with
	var time = abs(sin((target_rotation - get_parent().rotation.y) / (PI/2)))
	
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(
		get_parent(),
		"rotation:y",
		target_rotation,
		time
	)
	
	is_open = !is_open
	
	door_sound.stop()
	door_sound.play()


func check_to_leave() -> void:
	Event.emit_signal("left_for_work")



func reset() -> void:
	if is_open: 
		get_parent().rotation.y = 0.0
		is_open = false
