extends CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.connect("start_day", start_day)


func start_day() -> void:
	if GlobalRefs.day == 1:
		self.disabled = true
	
	if GlobalRefs.day == 4:
		self.disabled = false
