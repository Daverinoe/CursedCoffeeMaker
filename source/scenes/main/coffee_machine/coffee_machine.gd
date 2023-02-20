extends Node3D

class_name CoffeeMachine

enum STATES {
	OFF = 0,
	TURNING_ON = 1,
	TURNING_OFF = 2,
	EMPTY_GROUNDS = 3,
	EMPTY_BONES = 4,
	REFILL_WATER = 5,
	REFILL_BLOOD = 6,
	SACRIFICE_FLESH = 7,
	MAKING_COFFEE = 8,
	MENU = 9,
	READY = 10,
	WATER_TAKEN = 11,
	GROUNDS_TAKEN = 12,
	COFFEE_MADE = 13,
}

var interact_strings : Dictionary = {
	0: "to turn on.",
	1: "",
	2: "",
	3: "to open grounds container.",
	4: "to open bone receptacle.",
	5: "to remove water container.",
	6: "to remove phylactery.",
	7: "to SACRIFICE SELF.",
	8: "",
	9: "to ENJOY COFFEE.",
	10: "to make coffee.",
	11: "to replace water container.",
	12: "to replace grounds container.",
	13: "to drink coffee."
}

var display_strings : Dictionary = {
	0: "",
	1: "Good morning!",
	2: "Goodbye!",
	3: "EMPTY GROUNDS",
	4: "EMPTY GROUNDS",
	5: "REFILL WATER",
	6: "REFILL BLOOD",
	7: "SACRIFICE FLESH",
	8: "PLEASE WAIT",
	9: "ENJOY COFFEE",
	10: "READY",
	11: "REPLACE CONTAINER",
	12: "REPLACE CONTAINER",
	13: "ENJOY COFEE"
}

@export_category("End game variables")
@export var is_giant : bool = false

@export_category("Display variables")
@export var current_state : STATES = self.STATES.OFF
@export var display_on : bool = false

var interact_text : String = interact_strings[self.STATES.OFF]
var water_taken : bool = false
var grounds_taken : bool = false
var grounds_open_sound := preload("res://assets/sfx/coffee_machine/remove_grounds.ogg")
var grounds_replace_sound := preload("res://assets/sfx/coffee_machine/replace_grounds.ogg")
var water_open_sound := preload("res://assets/sfx/coffee_machine/remove_water.ogg")
var water_replace_sound := preload("res://assets/sfx/coffee_machine/replace_water.ogg")

@onready var display := $SubViewport/Display
@onready var animation_player := $AnimationPlayer
@onready var water_container := $water_container
@onready var grounds_container := $grounds_catcher
@onready var cup := $cup


func _ready() -> void:
	# Clear the viewport
	var viewport : SubViewport = $SubViewport
	viewport.set_clear_mode(SubViewport.CLEAR_MODE_ALWAYS)
	
	$ViewportQuad.material_override.albedo_texture = viewport.get_texture()
	change_display()
	if display_on:
		start_display()
		
	if !is_giant:
		Event.connect("start_day", start_day)
	
	if is_giant:
		current_state = STATES.SACRIFICE_FLESH
		Event.connect("start_day", giant_start_day)
		$Beans.visible = false
		interact_text = ""
		change_state(STATES.SACRIFICE_FLESH)
		
	
	Event.connect("begin_endgame", start_grind)
	Event.connect("begin_endscene", start_coffee)


func giant_start_day() -> void:
	if GlobalRefs.day == 4:
		self.visible = true


func start_grind() -> void:
	change_state(STATES.SACRIFICE_FLESH, true)
	interact_text = ""
	animation_player.play("GRIND")
	$CollisionShape3D.position.y = 0


func start_coffee() -> void:
	change_state(STATES.COFFEE_MADE, true)
	animation_player.play("MAKE_COFFEE")
	animation_player.advance(7)


func change_display() -> void:
	display.set_display_text(display_strings[current_state])


func start_display(set_loop: bool = true) -> void:
	Event.emit_signal("start_display")
	display.set_loop(set_loop)
	
	if current_state == STATES.MENU:
		display.set_loop(true)


func interact() -> void:
	match current_state:
		self.STATES.OFF:
			turn_on()
		self.STATES.EMPTY_GROUNDS:
			empty_grounds()
		self.STATES.EMPTY_BONES:
			empty_bones()
		self.STATES.REFILL_WATER:
			refill_water()
		self.STATES.WATER_TAKEN:
			refill_water()
		self.STATES.GROUNDS_TAKEN:
			empty_grounds()
		self.STATES.REFILL_BLOOD:
			refill_blood()
		self.STATES.READY:
			make_coffee()
		self.STATES.COFFEE_MADE:
			drink_coffee()


func change_state(new_state, override = false) -> void:
	if new_state == self.STATES.READY:
		if water_container.is_empty and !override:
			new_state = water_empty()
		if !grounds_container.is_empty and !override:
			new_state = grounds_empty()
		if cup.is_full and !override:
			new_state = self.STATES.COFFEE_MADE
	current_state = new_state
	interact_text = interact_strings[new_state]
	change_display()
	start_display()


func turn_on() -> void:
	change_state(self.STATES.TURNING_ON)
	animation_player.play("TURN_ON")
	
	await animation_player.animation_finished
	
	change_state(self.STATES.READY)


func empty_grounds() -> void:
	if !grounds_taken:
		animation_player.play("OPEN_GROUNDS")
		Event.emit_signal("water_taken")
		VariableManager.has_grounds = true
		grounds_taken = true
		change_state(self.STATES.GROUNDS_TAKEN)
		await animation_player.animation_finished
		move_to_player_hand(grounds_container, true)
		grounds_container.position = Vector3(1.006, 0.944, -3.051)
		grounds_container.rotation_degrees = Vector3(-17.5, 0, 0)
	else:
		VariableManager.has_grounds = false
		move_to_player_hand(grounds_container, false)
		animation_player.play("REPLACE_GROUNDS")
		grounds_taken = false
		await animation_player.animation_finished
		
		change_state(self.STATES.READY)


func empty_bones() -> void:
	empty_grounds()


func refill_water() -> void:
	if !water_taken:
		VariableManager.has_water = true
		animation_player.play("OPEN_WATER")
		Event.emit_signal("water_taken")
		water_taken = true
		change_state(self.STATES.WATER_TAKEN)
		await animation_player.animation_finished
		move_to_player_hand(water_container, true)
	else:
		VariableManager.has_water = false
		move_to_player_hand(water_container, false)
		animation_player.play("REPLACE_WATER")
		water_taken = false
		await animation_player.animation_finished
		
		change_state(self.STATES.READY)


func refill_blood() -> void:
	refill_water()


func sacrifice_flesh() -> void:
	pass


func make_coffee() -> void:
	if water_container.is_empty:
		return
	
	change_state(self.STATES.MAKING_COFFEE)
	animation_player.play("MAKE_COFFEE")
	
	await animation_player.animation_finished
	
	change_state(self.STATES.READY)


func water_empty() -> int:
	if GlobalRefs.day == 3:
		return self.STATES.REFILL_BLOOD
	
	return self.STATES.REFILL_WATER


func grounds_empty() -> int:
	if GlobalRefs.day == 1:
		return self.STATES.EMPTY_GROUNDS
	
	return self.STATES.EMPTY_BONES


func move_to_player_hand(node_ref, to_player) -> void:
	if to_player:
		self.remove_child(node_ref)
		GlobalRefs.grab_location.add_child(node_ref)
		node_ref.position = GlobalRefs.grab_location.position
	if !to_player:
		GlobalRefs.grab_location.remove_child(node_ref)
		self.add_child(node_ref)


func drink_coffee() -> void:
	
	animation_player.play("TAKE_CUP")
	await animation_player.animation_finished
	
	move_to_player_hand(cup, true)
	cup.position += Vector3(1.2, 2.0, -1.0)
	
	cup.animation_player.play("DRINK_COFFEE")
	await cup.animation_player.animation_finished
	
	move_to_player_hand(cup, false)
	
	animation_player.play("REPLACE_CUP")
	await animation_player.animation_finished
	
	Event.emit_signal("drank_coffee")
	
	change_state(self.STATES.READY)


func start_day() -> void:
	match GlobalRefs.day:
		1:
			self.scale = Vector3(0.25, 0.25, 0.25)
		2:
			self.scale = Vector3(0.35, 0.35, 0.35)
			$Beans/Beans2.scale.y = 0.75
		3:
			self.scale = Vector3(0.5, 0.5, 0.5)
			$Beans/Beans2.scale.y = 0.5
		4:
			self.scale = Vector3(0.25, 0.25, 0.25)
			$Beans.visible = false
			if !is_giant:
				self.visible = false
	
	
	VariableManager.machine_scale = self.scale
	water_container.change_liquid_level(0.5 * VariableManager.machine_scale.x, 0.1)
