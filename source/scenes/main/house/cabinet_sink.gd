extends StaticBody3D

var interact_text = " to refill container."
var can_interact : bool = false

var original_position : Vector3
var target_rotation : Vector3 = Vector3(-21.6, 46.7, -2.5)
var target_position : Vector3 = Vector3(0.182, 0.768, 0.315)

@onready var water_particles := $Water
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	if VariableManager.has_water and GlobalRefs.water_container.is_empty:
		interact_text = " to refill container."
		can_interact = true
	else:
		interact_text = ""
		can_interact = false


func interact() -> void:
	if can_interact:
		can_interact = false
		
		take_container()
		await animation_player.animation_finished
		
		water_particles.emitting = true
		GlobalRefs.water_container.refill_container()
		await get_tree().create_timer(3).timeout
		water_particles.emitting = false
		
		give_container()


func take_container() -> void:
	var water_can = GlobalRefs.water_container
	water_can.scale = VariableManager.machine_scale
	GlobalRefs.grab_location.remove_child(water_can)
	$%grab_point.add_child(water_can)
	water_can.position = Vector3.ZERO
	water_can.rotation = Vector3.ZERO
	animation_player.play("REFILL_WATER")

func give_container() -> void:
	animation_player.play_backwards("REFILL_WATER")
	
	var water_can = GlobalRefs.water_container
	$%grab_point.remove_child(water_can)
	GlobalRefs.grab_location.add_child(water_can)
	water_can.scale = Vector3.ONE
