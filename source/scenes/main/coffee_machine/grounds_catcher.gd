extends Node3D

@export var is_empty : bool = true

var grounds_level : int

@onready var dirt_ref := $dirt


func _ready() -> void:
	GlobalRefs.grounds_container = self


func increase_grounds() -> void:
	grounds_level += 1
	
	if grounds_level >= 3:
		is_empty = false
		dirt_ref.visible = true


func reset_grounds() -> void:
	is_empty = true
	dirt_ref.visible = false
