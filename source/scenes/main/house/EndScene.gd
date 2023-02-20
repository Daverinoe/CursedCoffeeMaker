extends Camera3D

@onready var animation_player = $"../AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.connect("begin_endscene", begin_endscene)


func begin_endscene() -> void:
	self.current = true
	%blackout.self_modulate.a = 1
	await get_tree().create_timer(2).timeout
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(
		%blackout,
		"self_modulate:a",
		0,
		1
	)
	
	animation_player.play("ENDSCENE")
	
	await get_tree().create_timer(20).timeout
	
	Event.emit_signal("end_day")
	AudioManager.stop_all()
	SceneManager.emit_signal("change_scene_to_file", get_parent(), GlobalRefs.main_menu_path)
