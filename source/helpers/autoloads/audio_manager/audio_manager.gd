extends Node

var subtitles_enabled: bool = true

var bus_list : Dictionary = {
	"master": 0,
	"music": 1,
	"effects": 2,
	"ambience": 3,
	"voices": 4,
}

var current_footsteps : AudioStreamPlayer

var active_music : AudioStreamPlayer

func _ready() -> void:
	randomize()
	Event.connect("change_floor", change_footsteps)
	Event.connect("play_footsteps", play_footsteps)
	Event.connect("stop_footsteps", stop_footsteps)


func set_volume(bus_name: String, value: float) -> void:
	var volume = linear_to_db(clamp(value, 0.0, 1.0))
	AudioServer.set_bus_volume_db(bus_list[bus_name], volume)


func play_sound(sound_name: String) -> void:
	var node_string : NodePath = "./NonSpatialEffects/" + sound_name
	var non_spatial_effect : AudioStreamPlayer = self.get_node(node_string)
	non_spatial_effect.play()


func play_footsteps() -> void:
	if !current_footsteps:
		change_footsteps()
	
	if current_footsteps and !current_footsteps.playing:
		current_footsteps.play()


func stop_footsteps() -> void:
	if current_footsteps and current_footsteps.playing:
		current_footsteps.stop()


func change_footsteps() -> void:
	stop_footsteps()
	
	var node_string : NodePath = "./Footsteps/footstep_" + GlobalRefs.current_floor
	current_footsteps = self.get_node(node_string)


func play_music(music_name, position_override = 0.0) -> void:
	if active_music:
		active_music.stop()
	
	var node_string : NodePath = "./Music/" + music_name
	active_music = self.get_node(node_string)
	active_music.play(position_override)


func play_voice(voice_name) -> void:
	var node_string : NodePath = "./Voice/" + voice_name
	var player_ref : AudioStreamPlayer = self.get_node(node_string)
	player_ref.play()
	show_subtitle(voice_name, player_ref)


func show_subtitle(voice_name, player_ref) -> void:
	if !subtitles_enabled:
		return
	var subtitle_ref : RichTextLabel = %Subtitles
	subtitle_ref.visible = true
	subtitle_ref.text = "[center]"
	match voice_name:
		"morning_1":
			subtitle_ref.text += "[YAWNS] What a lovely morning! Well, time to try out my new coffee machine, then get ready for work!"
		"morning_2":
			subtitle_ref.text += "[SIGHS] What a week! I definitely need that coffee this morning."
		"morning_3":
			subtitle_ref.text += "[GRUNT] This last week has. Been. Hell. I'm going to need all the coffee I can get!"
		"morning_4":
			subtitle_ref.text += "[GRUNT] I'll need a coffee to deal with this shit."
		"confused":
			subtitle_ref.text += "Huh. I thought I drank that already. Oh well! Another coffee!"
		"after_shower":
			subtitle_ref.text += "Phew! Well, after that, I think I need another coffee!"
		"acceptance":
			subtitle_ref.text += "I... I know what I need to do."
		"drink_coffee":
			subtitle_ref.text += "Wow! What an amazing coffee! Well, I guess it's time to finish getting ready."
		"empty_BONES":
			subtitle_ref.text += "What the!? I must still be half asleep! Those grounds looked like bones!"
		"dont_leave":
			subtitle_ref.text += "You know what? I better have another coffee before I go. You know, for the road!"
	
	await player_ref.finished
	await get_tree().create_timer(3).timeout
	subtitle_ref.visible = false

func stop_all() -> void:
	%Subtitles.visible = false
	for node in get_tree().get_nodes_in_group("audio"):
		node.stop()


func enable_subtitles(new_bool) -> void:
	if %Subtitles.visible and !new_bool:
		%Subtitles.visible = false
	subtitles_enabled = new_bool
