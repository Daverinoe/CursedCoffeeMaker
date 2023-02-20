extends CharacterBody3D

var speed = 100.0
var sensitivity = 0.05
var gravity = -9.8
var movement_speed = 100

var player_rotation : Vector2
var mouse_captured : bool = false
var can_move : bool = false

var footstep_audio_player : AudioStreamPlayer

var check_collisions : bool = true
var grav_vel : Vector3

@onready var camera : Camera3D = $Camera3D
@onready var ray : RayCast3D = $Camera3D/RayCast3D
@onready var onscreen_text : Label = $UI/Control/Label
@onready var walk_check : RayCast3D = $WalkCheck
@onready var grab_location := $Camera3D/GrabSpot

func _ready() -> void:
	Event.connect("toggle_mouse_capture", toggle_mouse_capture)
	Event.connect("start_day", start_day)
	Event.connect("end_day", end_day)
	toggle_mouse_capture()
	GlobalRefs.player = self
	GlobalRefs.grab_location = grab_location
	grab_location.scale = VariableManager.machine_scale
	
	Event.connect("begin_endscene", uncurrent_camera)


func toggle_mouse_capture() -> void:
	if !mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = !mouse_captured


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: player_rotation = event.relative * SettingsManager.get_setting("gameplay/mouse_sensitivity")
	if event.is_action_pressed("interact"): interact()
	if event.is_action_pressed("ui_cut") and OS.has_feature("editor"): Event.emit_signal("end_day")
	if event.is_action_pressed("ui_paste") and OS.has_feature("editor"): GlobalRefs.player.position = Vector3(40, 0, -3)


func _physics_process(delta: float) -> void:
	# Handle movement
	if can_move:
		rotate_player(delta)
		velocity = walk(delta) + _gravity(delta)
		move_and_slide()
	
	# Check interaction
	if check_collisions:
		check_interactivity()
	
	
		# Check walking surface
		check_walking_surface()
		
		# Check and set footstep audio
		var speed_check : bool = velocity.length() >= 0.05
		set_footsteps(speed_check)

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel


func rotate_player(delta: float) -> void:
	player_rotation += (Input.get_vector("turn_left", "turn_right", "look_up", "look_down")
	* SettingsManager.get_setting("gameplay/turn_speed")
	* 2)
	camera.rotation.y -= player_rotation.x * delta
	camera.rotation.x = clamp(camera.rotation.x - player_rotation.y * delta, -1.5, 1.5)
	player_rotation = Vector2.ZERO


func walk(delta: float) -> Vector3:
	# Get direction we want to walk
	var direction: Vector2 = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
	
	# Multiply onto direction we're facing, to get a modified 
	var foward_direction = camera.transform.basis * Vector3(direction.x, 0, direction.y)

	var walk_direction = foward_direction.normalized() * Vector3(1, 0, 1)
	return walk_direction * movement_speed * delta


func interact() -> void:
	if !ray.is_colliding():
		return
	
	var collider = ray.get_collider()
	print(collider.name)
	if collider.has_method("interact"):
		collider.interact()


func fade_in() -> void:
	var tween : Tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property(
		%blackout,
		"self_modulate:a",
		0,
		3
	)
	
	tween.play()
	
	await tween.finished
	check_collisions = true
	can_move = true


func fade_out(duration = 3) -> Tween:
	check_collisions = false
	onscreen_text.visible = false
	can_move = false
	var tween : Tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property(
		%blackout,
		"self_modulate:a",
		1,
		duration
	)
	
	return tween


func check_interactivity() -> void:
	if !ray.is_colliding():
		onscreen_text.visible = false
		return
	
	var collider = ray.get_collider()
	if collider.has_method("interact"):
		if !collider.interact_text == "":
			var interact_key = OS.get_keycode_string(InputManager.get_key("interact"))
			onscreen_text.text = interact_key + " " + collider.interact_text
			onscreen_text.visible = true


func check_walking_surface() -> void:
	if !walk_check.is_colliding():
		return
	
	var collider = walk_check.get_collider()
	if collider.has_method("set_floor_type"):
		collider.set_floor_type()


func set_footsteps(should_play: bool) -> void:
	if should_play:
		Event.emit_signal("play_footsteps")
	if !should_play:
		Event.emit_signal("stop_footsteps")


func start_day() -> void:
	camera.rotation = Vector3.ZERO
	camera.rotation_degrees.y = 180
	fade_in()
	match GlobalRefs.day:
		1:
			AudioManager.play_voice("morning_1")
		2:
			AudioManager.play_voice("morning_2")
		3:
			AudioManager.play_voice("morning_3")
		4:
			AudioManager.play_voice("morning_4")


func end_day() -> void:
	var tween = fade_out()
	await tween.finished
	Event.emit_signal("player_fadein")


func disable_ray() -> void:
	camera.rotation = Vector3.ZERO
	camera.rotation_degrees.y = 180
	ray.enabled = false


func uncurrent_camera() -> void:
	camera.current = false
