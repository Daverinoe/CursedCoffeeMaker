extends Node3D


@onready var display_text = $CoffeeText

func set_display_text(new_text) -> void:
	display_text.text_to_show = new_text


func set_loop(new_state : bool) -> void:
	display_text.loop_text = new_state
