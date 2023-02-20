extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_to_group("day2")
	self.add_to_group("reset")


func reset() -> void:
	if GlobalRefs.day == 1:
		self.visible = false
