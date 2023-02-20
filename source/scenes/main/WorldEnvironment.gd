extends WorldEnvironment

var night_sky = preload("res://assets/skies/night_sky.tres")
var day_sky = preload("res://assets/skies/normal_sky.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.connect("start_day", start_day)


func start_day() -> void:
	if GlobalRefs.day == 1:
		self.environment.background_energy_multiplier = 1
		self.environment.sky = day_sky
	if GlobalRefs.day == 2:
		self.environment.background_energy_multiplier = 0.66
	if GlobalRefs.day == 3:
		self.environment.background_energy_multiplier = 0.33
	if GlobalRefs.day == 4:
		self.environment.background_energy_multiplier = 1
		self.environment.background_mode = Environment.BG_CLEAR_COLOR
