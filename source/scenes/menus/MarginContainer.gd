extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.connect("change_font_size", change_font_size)


func change_font_size(new_size) -> void:
	var theme = get_theme()
	var newer_size = clamp(ceil(new_size * VariableManager.max_font_size), VariableManager.min_font_size, VariableManager.max_font_size)
	theme.set_font_size("", "", newer_size)
