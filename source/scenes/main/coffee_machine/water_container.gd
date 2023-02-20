extends Node3D

var tween : Tween

var is_empty : bool = false

var base_height : float = VariableManager.base_liquid_height * VariableManager.machine_scale.x

@onready var liquid := $liquid


func _ready() -> void:
	GlobalRefs.water_container = self
	Event.connect("start_day", start_day)


func change_liquid_level(new_level: float, duration: float) -> void:
	tween = get_tree().create_tween()
	
	tween.tween_property(
		liquid,
		"liquid_height",
		new_level,
		duration
	)


func make_coffee() -> void:
	var current_height = liquid.liquid_height
	var drop_amount = (VariableManager.base_liquid_height) * VariableManager.machine_scale.x
	var new_level = clamp(current_height - drop_amount, -base_height, base_height)
	change_liquid_level(new_level, 18)
	
	if new_level <= -base_height:
		is_empty = true


func refill_container() -> void:
	$WaterSound.play()
	change_liquid_level(base_height, 3)
	is_empty = false
	await get_tree().create_timer(3).timeout
	$WaterSound.stop()


func start_day() -> void:
	base_height = VariableManager.base_liquid_height * VariableManager.machine_scale.x
	is_empty = false
	change_liquid_level(base_height, 0.1)
