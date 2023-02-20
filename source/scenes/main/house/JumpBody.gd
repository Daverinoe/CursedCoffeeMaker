extends StaticBody3D


var interact_text := "to END CURSED EXISTENCE."
var player


@onready var jump_track := $"../Marker3D"


func interact() -> void:
	Event.emit_signal("jump")
	player = GlobalRefs.player
	
	player.disable_ray()
	
	player.can_move = false
	player.position = Vector3.ZERO
	player.rotation = Vector3.ZERO
	
	player.get_parent().remove_child(player)
	
	
	jump_track.add_child(player)
	
	$"../AnimationPlayer".play("JUMP")
	
	await $"../AnimationPlayer".animation_finished
	
	player.queue_free()
	Event.emit_signal("begin_endscene")


func fade_out() -> void:
	player.fade_out(1.1)
