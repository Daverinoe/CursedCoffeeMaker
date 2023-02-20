extends Node3D

@export var will_die : bool = false
@export var die_day : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.connect("start_day", start_day)


func start_day() -> void:
	if will_die and die_day == GlobalRefs.day:
		set_light(0, 0)
		return
	
	if GlobalRefs.day == 2:
		set_light(4.5, 0.9)
	
	if GlobalRefs.day == 3:
		set_light(4, 0.8)
	
	if GlobalRefs.day == 4:
		set_light(6, 0.2)


func set_light(lrange, energy) -> void:
	$OmniLight3D.omni_range = lrange
	$OmniLight3D.light_energy = energy
