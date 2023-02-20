extends MainScene

func _ready() -> void:
	
	for node in get_tree().get_nodes_in_group("reset"):
		node.reset()
	
	SerialisationManager.add_to_persist(self)
	GlobalRefs.level_ref = self
	
	for node in get_tree().get_nodes_in_group("ChangesWithDay"):
		node.change_day()
	
	Event.connect("start_day", start_day)
	Event.connect("end_day", end_day)
	



func save() -> Dictionary:
	return {
		name: {
#			"sky_rotation": $WorldEnvironment.environment.sky_rotation.y
		}
	}


func load_data(incoming_data: Dictionary) -> void:
	$WorldEnvironment.environment.sky_rotation.y = incoming_data["sky_rotation"]


func start_day() -> void:
	match GlobalRefs.day:
		1:
			AudioManager.play_music("day1_music")
		2:
			AudioManager.play_music("day2_music")
		3:
			AudioManager.play_music("day3_music")
		4:
			AudioManager.play_music("day4_music")


func end_day() -> void:
	GlobalRefs.day += 1
	await Event.player_fadein
	GlobalRefs.player.position = Vector3(-5.024, 0, -3.31)
	
	for node in get_tree().get_nodes_in_group("day" + var_to_str(GlobalRefs.day)):
		node.visible = !node.visible
	for node in get_tree().get_nodes_in_group("reset"):
		node.reset()
	
	Event.emit_signal("start_day")

