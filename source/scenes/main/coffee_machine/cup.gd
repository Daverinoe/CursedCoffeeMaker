extends Node3D

@export var is_full : bool = false

var tween : Tween
var empty_level := -0.8
var full_level := 0.8

@onready var coffee := $%Liquid
@onready var animation_player := $AnimationPlayer

func pour_coffee(duration) -> void:
	tween = get_tree().create_tween()
	
	tween.tween_property(
		coffee,
		"position:y",
		full_level,
		duration
	)
	
	is_full = true


func empty_coffee(duration) -> void:
	tween = get_tree().create_tween()
	
	tween.tween_property(
		coffee,
		"position:y",
		empty_level,
		duration
	)
	
	is_full = false
