extends Node3D

var coffee_machine = preload("res://source/scenes/main/coffee_machine/coffee_machine.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in self.get_children():
		child.add_to_group("day4")
	self.add_to_group("reset")


func reset() -> void:
	if GlobalRefs.day == 1:
		$lamp.visible = false
		$lamp2.visible = false
		$shelf.visible = true
		$Wall13.visible = true
		$Wall13.position.y = -0.163
		$WallWithDoor4.visible = false
		$MoreMess.visible = false
	
	if GlobalRefs.day == 4:
		$Wall13.position.y = -100.0
		var new_machine = coffee_machine.instantiate()
		new_machine.scale = Vector3(3, 3, 3)
		new_machine.rotation_degrees = Vector3(0, -50, 0)
		new_machine.position = Vector3(43.4, 0, -5.3)
		new_machine.is_giant = true
		new_machine.current_state = CoffeeMachine.STATES.SACRIFICE_FLESH
		new_machine.display_on = true
		
		$"../..".add_child(new_machine)
