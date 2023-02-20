extends StaticBody3D

var interact_text = "to take shower."

func interact() -> void:
	GlobalRefs.player.fade_out()
	
	$ShowerSound.play()
	await get_tree().create_timer(5).timeout
	
	GlobalRefs.player.fade_in()
	
	Event.emit_signal("took_shower")
