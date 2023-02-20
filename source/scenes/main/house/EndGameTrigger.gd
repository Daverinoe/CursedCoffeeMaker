extends Area3D

var triggered := false


func _on_body_entered(body: Node3D) -> void:
	if !triggered:
		Event.emit_signal("drank_coffee")
		Event.emit_signal("begin_endgame")
		AudioManager.play_music("day4_music", 88)
