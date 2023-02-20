extends StaticBody3D

var interact_text = " to empty container."
var can_interact : bool = false

var original_position : Vector3
var target_rotation : Vector3 = Vector3(-21.6, 46.7, -2.5)
var target_position : Vector3 = Vector3(0.182, 0.768, 0.315)

@onready var empty_particles := $Dirt
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	if VariableManager.has_grounds and !GlobalRefs.grounds_container.is_empty:
		interact_text = " to empty container."
		can_interact = true
	else:
		interact_text = ""
		can_interact = false


func interact() -> void:
	if can_interact:
		can_interact = false
		
		take_container()
		await animation_player.animation_finished
		
		give_container()


func take_container() -> void:
	var grounds_can = GlobalRefs.grounds_container
	grounds_can.scale = VariableManager.machine_scale
	GlobalRefs.grab_location.remove_child(grounds_can)
	$%grab_point.add_child(grounds_can)
	grounds_can.position = Vector3.ZERO
	grounds_can.rotation = Vector3.ZERO
	animation_player.play("EMPTY_GROUNDS")

func give_container() -> void:	
	var grounds_can = GlobalRefs.grounds_container
	$%grab_point.remove_child(grounds_can)
	GlobalRefs.grab_location.add_child(grounds_can)
	grounds_can.scale = Vector3.ONE
	
	grounds_can.position = Vector3(1.006, 0.944, -3.051)
	grounds_can.rotation_degrees = Vector3(-17.5, 0, 0)


func reset_grounds() -> void:
		GlobalRefs.grounds_container.reset_grounds()


func ready_day() -> void:
	pass
